class PhotosController < ApplicationController
  def index
    # TODO: Add filter bar
    # TODO: Add scrollbar
    # TODO: Add photo modals
    # TODO: Add listener to recenter map on clicked-on photo
    # TODO: The current view should be extracted out into map#index and a new page for photos#index should be created here
    @photos = Photo.all.with_image.belongs_to_user(current_user)
  end

  def show
    @photo = Photo.with_image.belongs_to_user(current_user).find(params[:id])
    @comment = Comment.new
  end

  def new
    @photo = Photo.new
    # TODO: multiple file uploads
    # TODO: drag and drop for uploads
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
