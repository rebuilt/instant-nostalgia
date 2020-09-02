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
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    respond_to do |format|
      if @photo.save
        @photo.init
        format.html { redirect_to photos_path }
      else
        format.html { render :new }
      end
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
