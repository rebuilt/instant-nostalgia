class SharesController < ApplicationController
  def index
    @my_albums = Album.where(user: current_user)
    @shared_with_me = current_user.authorized_albums
  end

  def new
    @album = Album.find(params[:album_id])
    @share = Share.new

    if params[:search].present?
      @term = params[:search]
      # TODO: pagify user search
      @users = User.search(@term)

      # don't include self in list of users to share with
      @users = @users.reject { |user| user == current_user }

      # don't include users that already have access to the album
      @album.users.each do |already_authorized_user|
        @users = @users.reject do |user|
          user == already_authorized_user
        end
      end
    end

    respond_to do |format|
      format.html {}
      format.js { render :new }
    end
  end

  def create
    user_id = params[:user_id]
    album_id = params[:album_id]
    @share = Share.new(user_id: user_id.to_i, album_id: album_id.to_i)
    if @share.save
      redirect_to shares_path
    else
      render :new
    end
  end
end
