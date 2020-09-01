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
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :user_id, :photos_id)
  end
end
