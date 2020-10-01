class PhotosController < ApplicationController
  before_action :has_remaining_uploads, only: %i[create]

  def index
    @photos = Photo.with_attached_image.belonging_to_user(current_user).includes(:user).order_by_new_to_old
  end

  def show
    # TODO: change this from belonging_to_user to belonging_or_shared_with(current_user)
    @photo = Photo.with_attached_image.find(params[:id])
    @comments = Comment.with_rich_text_body.order_by_old_to_new.where(commentable_id: @photo).includes(:user)
    @comment = Comment.new
  end

  def new
    @photo = Photo.new
    @uploads_remaining = 100 - current_user.photos.count
    @uploads_remaining = 0 if @uploads_remaining.negative?
    # TODO: multiple file uploads
    # TODO: drag and drop for uploads
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    respond_to do |format|
      if @photo.save
        successful_upload(format) if @photo.init
        failure_upload(format) unless @photo.init
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy if can_delete_photo?(current_user, @photo)
    respond_to do |format|
      format.html { redirect_to photos_path }
      format.js { render :destroy }
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end

  def can_delete_photo?(user, photo)
    user == photo.user
  end

  def successful_upload(format)
    notice = 'Photo uploaded and location data found'
    format.html { redirect_to maps_path, success: notice }
  end

  def failure_upload(format)
    error = 'Photo does not contain location data. Photo is unmappable.'
    format.html { redirect_to maps_path, alert: error }
  end

  def has_remaining_uploads
    redirect_to new_photo_path unless (100 - current_user.photos.count).positive?
  end
end
