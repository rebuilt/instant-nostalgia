class PhotosController < ApplicationController
  def index
    # OPTIMIZE: Do these two lines do the same thing?  Am I correctly handling the n+1 problem?
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user)
    # @photos = Photo.all.includes(image_attachment: :blob).belonging_to_user(current_user)
  end

  def show
    @photo = Photo.with_attached_image.belonging_to_user(current_user).find(params[:id])
    @comments = Comment.with_rich_text_body.order_by_old_to_new.where(commentable_id: @photo).includes(:user)
    # @comments = Comment.joins(:user).with_rich_text_body.order_by_old_to_new.where(commentable_id: @photo)
    # @comments = Comment.with_rich_text_body.order_by_old_to_new.where(commentable_id: @photo).includes(:user)
    # @comments = Comment.with_rich_text_body.order_by_old_to_new.joins(:user).where(commentable_id: @photo)
    # @comments = Comment.with_rich_text_body.order_by_old_to_new.includes(:user).where(commentable_id: @photo)
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
    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
