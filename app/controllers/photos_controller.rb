class PhotosController < ApplicationController
  before_action :has_remaining_uploads, only: %i[create]
  before_action :ensure_logged_in, only: %i[index new create delete destroy]
  before_action :authorized_to_view, only: %i[show]

  def index
    @pagy, @photos = pagy(Photo.with_attached_image
                   .belonging_to_user(current_user)
                   .includes(:user)
                   .order_by_new_to_old)
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
    @uploads_remaining = current_user.remaining_uploads

    params[:image].each_with_index do |blob, index|
      break unless @uploads_remaining.positive?

      @photo = Photo.new(image: blob, user: current_user)
      if @photo.save
        @photo.init

        @uploads_remaining -= 1

        ReverseGeocodeJob.set(wait: index.seconds).perform_later(@photo)
      else
        flash[:alert] = @photo.errors.full_messages
      end
    end
    render :new
  end

  def delete
    @pagy, @photos = pagy(Photo.with_attached_image
                   .belonging_to_user(current_user)
                   .includes(:user)
                   .order_by_new_to_old)
  end

  def destroy
    params[:checked].each do |photo_id, _value|
      @photo = Photo.find(photo_id)
      @photo.destroy if is_owner?(current_user, @photo)
    end

    redirect_to photos_delete_path
  end

  private

  def photo_params
    params.require(:photo).permit(images: [])
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

  def authorized_to_view
    @photo = Photo.find(params[:id])
    can_view = false

    # Can view the photo if it's public
    @photo.albums.each do |album|
      can_view = true if album.public
    end

    # Can view the photo if it's been shared with them
    @photo.authorized_users.each do |user|
      can_view = true if logged_in? && current_user == user
    end

    # Can view the photo if it belongs to them
    can_view = true if logged_in? && current_user == @photo.user

    redirect_to login_path unless can_view
  end
end
