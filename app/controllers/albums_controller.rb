class AlbumsController < ApplicationController
  before_action :ensure_logged_in, only: %i[toggle_public index create destroy]
  before_action :load_album, only: %i[toggle_public destroy]
  before_action :ensure_owner, only: %i[toggle_public destroy]
  before_action :authorized_to_view, only: %i[show]

  def index
    @album = Album.new
    @albums = Album.where(user: current_user.id)
    @pagy, @photos = pagy(Photo.with_attached_image.belonging_to_user(current_user))
  end

  def show
    # empty method.  @album variable populated by before_action, :authorized_to_view
  end

  def create
    @album = Album.new(album_params)
    @album.user = current_user

    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path, notice: 'Album was successfully created.' }
        format.js { render :create }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @album.destroy
        format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
        format.js { render :destroy }
      else
        redirect_to albums_url, notice: 'Error.  Album was not destroyed.'
      end
    end
  end

  def toggle_public
    @album.toggle! :public
  end

  private

  def album_params
    params.require(:album).permit(:title, :user_id, :photos_id)
  end

  def load_album
    @album = Album.find(params[:id]) if params[:id].present?
    @album = Album.find(params[:album_id]) if @album.nil?
    @album
  end

  def ensure_owner
    redirect_to album_path(@album) unless is_owner?(current_user, @album)
  end

  def authorized_to_view
    @album = Album.include_images.find(params[:id])
    can_view = false
    can_view = true if logged_in? && is_owner?(current_user, @album)
    can_view = true if @album.public
    can_view = true if logged_in? && current_user.authorized_albums.include?(@album)
    redirect_to login_path unless can_view
  end
end
