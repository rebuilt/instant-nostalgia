class SharesController < ApplicationController
  def index
    @shared_by_me = Album.where(user: current_user)
    @shared_with_me = User.find(current_user.id).shares
  end

  def new
    @album = Album.find(params[:album_id])
    @share = Share.new

    if params[:search].present?
      @term = params[:search]
      @users = User.where('email LIKE ?', "%#{@term}%")
      @users = @users.reject { |user| user == current_user }
    end

    respond_to do |format|
      format.html {}
      format.js { render :new }
    end
  end

  def create
    user_id = params[:user_id]
    album_id = params[:album_id]
    @share = Share.new(user_id: user_id.to_i, album_id: album_id.to_i)
    if @share.save
      redirect_to shares_path
    else
      render :new
    end
  end
end
