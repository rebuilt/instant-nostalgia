class PhotoUploadsController < ApplicationController
  before_action :ensure_logged_in, only: %i[create]

  def create
    @uploads_remaining = current_user.remaining_uploads

    puts params[:image]
    params[:image].each_with_index do |blob, index|
      break unless @uploads_remaining.positive?

      @photo = Photo.create(image: blob, user: current_user)
      @photo.init

      @uploads_remaining -= 1

      ReverseGeocodeJob.set(wait: index.seconds).perform_later(@photo)
    end
  end
end
