class PhotosController < ApplicationController
  before_action :has_remaining_uploads, only: %i[create]
  before_action :ensure_logged_in, only: %i[index new create destroy]

  def index
    @photos = Photo.with_attached_image
                   .belonging_to_user(current_user)
                   .includes(:user)
                   .order_by_new_to_old
  end

  def show
    @photo = Photo.with_attached_image.find(params[:id])
    @comments = Comment.with_rich_text_body
                       .order_by_old_to_new
                       .where(commentable_id: @photo)
                       .includes(:user)
    @comment = Comment.new
  end

  def new
    @photo = Photo.new
    @uploads_remaining = current_user.remaining_uploads
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    @uploads_remaining = current_user.remaining_uploads

    respond_to do |format|
      if @uploads_remaining.positive? && @photo.save
        successful_upload(format) if @photo.init
        failure_upload(format) unless @photo.init
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy if is_owner?(current_user, @photo)
    respond_to do |format|
      format.html { redirect_to photos_path }
      format.js { render :destroy }
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
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
    redirect_to new_photo_path unless current_user.has_remaining_uploads?
  end
end
