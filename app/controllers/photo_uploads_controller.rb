class PhotoUploadsController < ApplicationController
  def create
    @photos = []
    params[:image].each do |blob|
      @uploads_remaining = current_user.remaining_uploads
      break unless @uploads_remaining.positive?

      @photo = Photo.new(image: blob, user: current_user)
      @photo.save
      @photo.init
      @photos << @photo
    end

    # ReverseGeocodeJob.perform_later @photos
    @photos.each_with_index do |photo, index|
      ReverseGeocodeJob.set(wait: index.seconds).perform_later(photo)
    end

    redirect_to photos_path, notice: 'Addresses are being processed in the background.  Please allow at least 2 seconds per photo for processing.  Some photos may not have location information and will not be mappable.'
  end

  private

  def photo_params
    params.require(:image).permit(:blob)
  end
end
