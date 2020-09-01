class PhotosController < ApplicationController
  def index
    @photos = Photo.all.includes(image_attachment: :blob)
  end

  def show
    @photo = Photo.includes(image_attachment: :blob).find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    photo = Photo.new(photo_params)
    photo.user = User.new
    photo.save
    photo.init
    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
