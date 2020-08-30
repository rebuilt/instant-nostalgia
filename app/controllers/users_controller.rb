class UsersController < ApplicationController
  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to ideas_path
    else
      render 'new'
    end
  end

  def edit; end
end
