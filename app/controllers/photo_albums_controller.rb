class PhotoAlbumsController < ApplicationController
  def update
    @album = Album.find(params[:album])

    # I'm not using _value variable but if I don't include it, I get both photo_id and value in a single string instead of separate id and value
    params[:checked].each do |photo_id, _value|
      @photo = Photo.find(photo_id)

      # don't include duplicates
      @album.photos << @photo unless @album.photos.include?(@photo)
    end

    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path, notice: 'Album was successfully updated.' }
      else
        format.html { redirect_to albums_path }
      end
    end
  end

  def destroy
    album_id = params[:id].split('/')[0]
    photo_id = params[:id].split('/')[1]

    @album = Album.find(album_id)
    @album.photos.delete(photo_id)
    redirect_to album_path(album_id)
  end
end
