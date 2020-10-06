class WelcomeController < ApplicationController
  before_action :redirect_authenticated, only: %i[index]

  def index
    # empty method
  end

  private

  def redirect_authenticated
    redirect_to photos_path if logged_in?
  end
end
