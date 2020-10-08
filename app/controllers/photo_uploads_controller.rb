class PhotoUploadsController < ApplicationController
  def create
    @uploads_remaining = current_user.remaining_uploads
    params[:image].each_with_index do |blob, index|
      next unless @uploads_remaining.positive?

      @photo = Photo.create(image: blob, user: current_user)
      @photo.init

      @uploads_remaining -= 1

      ReverseGeocodeJob.set(wait: index.seconds).perform_later(@photo)
    end
  end

  private

  def photo_params
    params.require(:image).permit(:blob)
  end
end
