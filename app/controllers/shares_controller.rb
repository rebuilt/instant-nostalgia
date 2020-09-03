class SharesController < ApplicationController
  def index
    @albums = Share.where(album_id: params[:id])
    @shares = Share.where(user_id: current_user)
  end

  def new
    puts params
  end

  def create; end
end
