class PhotosController < ApplicationController
  def index
    @photos = Photo.all.with_image.belongs_to_user(current_user)
  end

  def show
    @photo = Photo.with_image.belongs_to_user(current_user).find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    photo = Photo.new(photo_params)
    photo.user = current_user
    photo.save
    photo.init
    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
