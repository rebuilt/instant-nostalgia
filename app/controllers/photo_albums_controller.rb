class PhotoAlbumsController < ApplicationController
  before_action :ensure_checked_params, only: %i[update]

  def update
    @album = Album.find(params[:album])

    # TODO: make this a before Action
    # have to do this check in a before_action because a controller will execute the entire update method
    params[:checked].each do |photo_id, _value|
      @photo = Photo.find(photo_id)

      # don't include duplicates
      @album.photos << @photo unless @album.photos.include?(@photo)
    end

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_path(@album), notice: 'Album was successfully updated.' }
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

  private

  def ensure_checked_params
    redirect_to albums_path unless params[:checked].present?
  end
end
