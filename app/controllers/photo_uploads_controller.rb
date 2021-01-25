class PhotoUploadsController < ApplicationController
  before_action :ensure_logged_in, only: %i[create]

  def create
  end
end
