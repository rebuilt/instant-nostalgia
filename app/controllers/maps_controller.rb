class MapsController < ApplicationController
  def index
    @photos = load_photos_by_area(:city)
    # TODO: this should return most recent photos, not all photos
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user) if @photos.nil?
    @photos = @photos.reject { |photo| photo.location? == false }
    @cities = Photo.distinct.pluck(:city)
    @cities = @cities.reject(&:nil?)
  end

  private

  def load_photos_by_area(area)
    params[area]&.each do |key, value|
      next unless value == '1'

      tmp = Photo.where(area => key)
      @photos = @photos.present? ? @photos.or(tmp) : tmp
    end

    @photos
  end
end
