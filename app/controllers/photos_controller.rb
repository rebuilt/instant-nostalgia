class PhotosController < ApplicationController
  def index
    @photos = Photo.all.with_attached_image
    # @photos = Photo.all
  end

  def show; end

  def new
    @photo = Photo.new
  end

  def create
    photo = Photo.create(photo_params)
    metadata = photo.read_image_metadata
    photo.populate_with(metadata)
    photo.initialize_latlong_decimals
    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
