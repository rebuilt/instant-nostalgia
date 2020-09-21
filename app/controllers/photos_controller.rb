class PhotosController < ApplicationController
  def index
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user)
  end

  def show
    # TODO: change this from belonging_to_user to belonging_or_shared_with(current_user)
    @photo = Photo.with_attached_image.find(params[:id])
    @comments = Comment.with_rich_text_body.order_by_old_to_new.where(commentable_id: @photo).includes(:user)
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
        format.html { redirect_to maps_path }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_path }
      format.js { render :destroy }
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
