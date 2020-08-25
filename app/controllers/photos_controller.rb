class PhotosController < ApplicationController
  def index; end

  def show; end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photos_path }
      else
        format.html { render :new }
      end
    end
  end

  def photo_params
    params.require(:photo).permit(images: [])
  end
end
