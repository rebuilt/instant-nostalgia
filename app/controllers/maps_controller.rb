class MapsController < ApplicationController
  def index
    if params[:checked]
      params[:checked].each do |key, value|
        puts "key is: #{key} and value is: #{value}"
        next unless value == '1'

        tmp = Photo.where(city: key)
        @photos = @photos.present? ? @photos.or(tmp) : tmp
      end
    else
      @photos = Photo.all.with_attached_image.belonging_to_user(current_user)
    end

    @cities = Photo.distinct.pluck(:city)
  end
end
