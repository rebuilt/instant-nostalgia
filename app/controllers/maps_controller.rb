require_relative 'date_tools'

class MapsController < ApplicationController
  include MapsHelper
  def index
    flash.now[:message] = I18n.t 'controllers.maps.results'
    if logged_in?
      @photos = load_photos_by_area(:city) if params[:city].present?
      @photos = load_photos_by_area(:state) if params[:state].present?
      @photos = load_photos_by_area(:country) if params[:country].present?
      @photos = load_by_date if DateTools.date_populated?(params)
      @photos = load_by_date_range if DateTools.date_range_populated?(params)
      @photos = load_by_id if params[:photo_id].present?
      # Before this comment @photos is an activerecord relation.  After this comment, @photos is an array
      @photos = load_albums(:album) if params[:album].present?
      @photos = load_albums(:publicAlbum) if params[:publicAlbum].present?
      @photos = load_most_recent if @photos.nil?
      @photos = remove_non_geocoded(@photos)
      @cities = load_area_names(:city)
      @states = load_area_names(:state)
      @countries = load_area_names(:country)
      @albums = current_user.albums
      @shared_albums = current_user.authorized_albums
    else
      # If the user is not signed in
      @photos = load_albums(:publicAlbum) if params[:publicAlbum].present?
      load_default_album if @photos.nil?
    end

    @public_albums = Album.where(public: true)
    @public_albums = remove_empty_albums(@public_albums)
  end

  private

  def remove_empty_albums(albums)
    # remove any albums that don't have photos
    albums = albums.reject { |album| album.photos.length < 1 }
    # select only albums that have photos with locations
    albums.select { |album| album.photos.any? { |photo| photo.location? } }
  end

  def load(photos)
    @photos = @photos.present? ? @photos.or(photos) : photos
  end

  def load_default_album
    album = User.first.albums.first
    add_message('Default public album', album.title)
    @photos = album.photos
  end

  def load_most_recent
    count = 5
    add_message(I18n.t('controllers.maps.recent'), count.to_s)
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user).most_recent_mappable(count)
  end

  def load_by_id
    tmp = Photo.with_attached_image.where(id: params[:photo_id])
    photo = tmp[0]

    add_message('Photo', photo.id)
    load(tmp) if photo.location? && can_view_photo?(photo)
  end

  def load_photos_by_area(area)
    params[area]&.each do |key, value|
      next unless value == '1'

      add_message(area, key)
      tmp = Photo.with_attached_image.belonging_to_user(current_user).where(area => key)

      load(tmp)
    end

    @photos
  end

  def load_albums(name)
    params[name]&.each do |key, value|
      next unless value == '1'
      next unless can_view_album?(Album.find(key))

      album = Album.find(key)
      add_message(name, album.title)
      tmp = Photo.with_attached_image.joins(:albums).where(albums: { id: key })

      # Can't use load method here because I have joined on :albums.  This mixes two activerecord model types, Photo and Album. Meaning I will not be able to use .or method to add activerecord relations.  Instead I have to use the plus operator to join two arrays.  Any calls to load method after this point using .or will fail because @photos has been changed to an array from an activerecord relation.  Any operations on @photos after this method must assume it is an array.  This is related to bug fixed on checkout 585fd28
      @photos = @photos.present? ? @photos + tmp : tmp
    end
    @photos
  end

  def load_by_date
    day = params['day-selector']
    month = params['month-selector']
    add_message('Date', "#{day}-#{month}: (day-month)")
    tmp = Photo.with_attached_image.belonging_to_user(current_user).day_is(day).month_is(month)

    load(tmp)
  end

  def load_by_date_range
    start_date = DateTools.parse_date(params['start-date'], 'start')

    end_date = DateTools.parse_date(params['end-date'], 'end')

    add_message('Date range', "#{start_date} - #{end_date}")
    tmp = Photo.with_attached_image.belonging_to_user(current_user).date_between(start_date, end_date)

    load(tmp)
  end
end
