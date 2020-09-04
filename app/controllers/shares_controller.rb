class SharesController < ApplicationController
  def index
    @shared_by_me = Album.where(user: current_user)
    @shared_with_me = User.find(current_user.id).shares
  end

  def new
    @album = Album.find(params[:album_id])

    if params[:search].present?
      @term = params[:search]
      @users = User.where('email LIKE ?', "%#{@term}%")
    end
  end

  def create; end
end
