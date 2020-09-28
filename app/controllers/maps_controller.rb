class MapsController < ApplicationController
  def index
    if logged_in?
      @photos = load_photos_by_area(:city) if params[:city].present?
      @photos = load_photos_by_area(:state) if params[:state].present?
      @photos = load_photos_by_area(:country) if params[:country].present?
      @photos = load_by_date if params['day-selector'].present? && params['month-selector'].present?

      if params['start-date'].present? &&
         params['start-date']['start-date(1i)'].present? &&
         params['end-date'].present? &&
         params['end-date']['end-date(1i)'].present?
        @photos = load_by_date_range
      end

      @photos = load_albums if params[:album].present?

      @photos = Photo.all.with_attached_image.belonging_to_user(current_user).most_recent if @photos.nil?
      @photos = remove_non_geocoded(@photos)

      @cities = load_area_names(:city)
      @states = load_area_names(:state)
      @countries = load_area_names(:country)
      @albums = current_user.albums
      @shared_albums = current_user.authorized_albums
      @public_albums = Album.all
    else
      @photos = load_albums if params[:album].present?
      @public_albums = Album.all
    end
  end

  private

  def load_photos_by_area(area)
    params[area]&.each do |key, value|
      next unless value == '1'

      tmp = Photo.with_attached_image.belonging_to_user(current_user).where(area => key)
      @photos = @photos.present? ? @photos.or(tmp) : tmp
    end

    @photos
  end

  def load_albums
    params[:album]&.each do |key, value|
      next unless value == '1'

      tmp = Photo.with_attached_image.joins(:albums).where(albums: { id: key })
      @photos = @photos.present? ? @photos + tmp : tmp
    end
    @photos
  end

  def load_by_date
    day = params['day-selector']
    month = params['month-selector']
    tmp = Photo.with_attached_image.belonging_to_user(current_user).day_is(day).month_is(month)
    @photos = @photos.present? ? @photos.or(tmp) : tmp
    @photos
  end

  def load_by_date_range
    start_date = parse_date(params['start-date'], 'start')

    end_date = parse_date(params['end-date'], 'end')

    tmp = Photo.with_attached_image.belonging_to_user(current_user).date_between(start_date, end_date)
    @photos = @photos.present? ? @photos.or(tmp) : tmp
    @photos
  end

  def parse_date(info, prefix)
    year = info["#{prefix}-date(1i)"].to_i
    month = info["#{prefix}-date(2i)"].to_i
    day = info["#{prefix}-date(3i)"].to_i
    month = valid_month(prefix) if month == 0
    day, month, year = valid_day(day, month, year, prefix) if day == 0
    Date.new year, month, day
  end

  def valid_month(prefix)
    'start' == prefix ? 1 : 12
  end

  def valid_day(day, month, year, prefix)
    day = 1
    month, year = add_one_to_month(month, year) if prefix == 'end'

    [day, month, year]
  end

  def add_one_to_month(month, year)
    if month < 12
      month += 1
    else
      year += 1
      month = 1
    end
    [month, year]
  end

  def load_area_names(area)
    locations = Photo.belonging_to_user(current_user).distinct.pluck(area)
    locations.reject(&:nil?)
  end

  def remove_non_geocoded(photos)
    photos.reject { |photo| photo.location? == false }
  end
end
