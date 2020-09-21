class MapsController < ApplicationController
  def index
    places = %i[suburb village city state country]
    places.each do |place|
      @photos = load_photos_by_area(place) if params[place]
    end

    @photos = load_albums if params[:album]

    # TODO: this should return most recent photos, not all photos
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user) if @photos.nil?
    @photos = remove_non_geocoded(@photos)

    @suburbs = load_area_names(:suburb)
    @villages = load_area_names(:village)
    @cities = load_area_names(:city)
    @states = load_area_names(:state)
    @countries = load_area_names(:country)
    @albums = current_user.albums
    @shared_albums = current_user.authorized_albums
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

  def load_area_names(area)
    locations = Photo.distinct.pluck(area)
    locations.reject(&:nil?)
  end

  def load_albums
    params[:album]&.each do |key, value|
      next unless value == '1'

      tmp = Album.find(key).photos
      @photos = @photos.present? ? @photos.or(tmp) : tmp
    end
    @photos
  end

  def remove_non_geocoded(photos)
    photos.reject { |photo| photo.location? == false }
  end
end
