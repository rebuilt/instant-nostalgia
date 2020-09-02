class AlbumsController < ApplicationController
  def index
    @album = Album.new
    @albums = Album.all
  end

  def create
    @album = Album.new(album_params)
    @album.user = current_user

    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path, notice: 'Album was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :user_id, :photos_id)
  end
end
