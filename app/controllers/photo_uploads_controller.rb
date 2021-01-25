class PhotoUploadsController < ApplicationController
  before_action :ensure_logged_in, only: %i[create]

  def create
    puts '######################  in create method    ####################################'
    @uploads_remaining = current_user.remaining_uploads

    params[:image].each_with_index do |blob, index|
      break unless @uploads_remaining.positive?

      @photo = Photo.new(image: blob, user: current_user)
      if @photo.save
        puts '*********************  saving photo without errors *********************'
        @photo.init

        @uploads_remaining -= 1

        ReverseGeocodeJob.set(wait: index.seconds).perform_later(@photo)
      else
        puts '*********************   error saving photo *********************'
      end
    end
  end
end
