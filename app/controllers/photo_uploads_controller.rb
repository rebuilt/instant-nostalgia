class PhotoUploadsController < ApplicationController
  def create
    @photos = []
    params[:image].each do |blob|
      @photo = Photo.new(image: blob, user: current_user)
      @photo.save
      @photo.init
      @photos << @photo
    end

    @photos.each do |photo|
      sleep(2.seconds)
      photo.init_address
    end

    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:image).permit(:blob)
  end
end
