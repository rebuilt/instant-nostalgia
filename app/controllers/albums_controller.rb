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

  private

  def album_params
    params.require(:album).permit(:title, :user_id, :photos_id)
  end
end
