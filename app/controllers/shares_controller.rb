class SharesController < ApplicationController
  def index
    @my_albums = Album.where(user: current_user)
    @shared_with_me = current_user.authorized_albums
    @shares = Share.where(user_id: current_user.id).joins(:album)
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
    @share = Share.new(user_id: user_id, album_id: album_id)
    if @share.save
      respond_to do |format|
        format.html { redirect_to shares_path }
      end
    else
      render :new
    end
  end

  def destroy
    @share = Share.find(params[:id])
    @share.destroy if current_user == @share.album.user || current_user.id == @share.user_id

    redirect_to shares_path
  end

  private

  def remove_current_user(users)
    # don't include self in list of users to share with
    users.reject { |user| user == current_user }
  end

  def remove_already_authorized_users(album, users)
    # don't include users that already have access to the album
    album.users.each do |already_authorized_user|
      users = users.reject { |user| user == already_authorized_user }
    end
    users
  end
end
