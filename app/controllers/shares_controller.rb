class SharesController < ApplicationController
  include SharesHelper

  before_action :ensure_logged_in
  before_action :authorized_to_create, only: %i[new create]

  def index
    @my_albums = Album.where(user: current_user)
    @shared_with_me = current_user.authorized_albums.joins(:album)
    @shares = Share.where(user_id: current_user.id).joins(:album).joins(:user).select(:album_id, :user_id).distinct
  end

  def new
    @album = Album.find(params[:album_id])
    @share = Share.new

    if params[:search].present?
      @term = params[:search]

      @users = User.search(@term)
      @users = remove_current_user(@users)
      @users = remove_already_authorized_users(@album, @users)
    end

    respond_to do |format|
      format.html {}
      format.js { render :new }
    end
  end

  def create
    user_id = params[:user_id]
    album_id = params[:album_id]
    @album = Album.find(album_id)

    @album.photos.each do |photo|
      @share = Share.new(user_id: user_id, album_id: album_id, photo_id: photo.id)
      if @share.save
      else
        flash.now[:alert] = 'Error sharing album'
        render :new
      end
    end

    has_errors = false
    if @album.photos.count.zero?
      has_errors = true
      flash.now[:alert] = "Can't share an empty album.  Please add photos before sharing album"
    end

    if has_errors
      @share ||= Share.new
      render :new
    else
      redirect_to shares_path
    end
  end

  def destroy
    @shares = Share.where(user_id: params[:user_id],
                          album_id: params[:album_id])

    @shares.each do |share|
      share.destroy if can_destroy_share?(share)
    end

    redirect_to shares_path
  end

  private

  def authorized_to_create
    @album = Album.find(params[:album_id])
    redirect_to login_path unless is_owner?(current_user, @album)
  end
end
