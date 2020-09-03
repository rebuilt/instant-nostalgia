class PhotoAlbumsController < ApplicationController
  def update
    @album = Album.find(params[:album])
    params[:checked].each do |photo_id, _value|
      @photo = Photo.find(photo_id)
      @album.photos << @photo
    end
    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path, notice: 'Album was successfully updated.' }
      else
        format.html { redirect_to albums_path }
      end
    end
  end
end
