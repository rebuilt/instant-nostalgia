class AlbumsController < ApplicationController
  def index
    @album = Album.new
    @albums = Album.where(user: current_user.id)
    @photos = Photo.with_attached_image.belonging_to_user(current_user)
  end

  def show
    # TODO: pagify album contents

    @album = Album.include_images.find(params[:id])
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

  def update
    # empty method
  end

  def destroy
    @album = Album.find(params[:id])

    @album.destroy if can_delete?(current_user, album)
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.js { render :destroy }
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :user_id, :photos_id)
  end

  def can_delete?(user, album)
    user == album.user
  end
end
