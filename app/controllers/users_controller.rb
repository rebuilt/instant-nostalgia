class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update destroy]
  def index
    @users = User.all
  end

  def show
    # empty method
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_photo_path
    else
      flash[:alert] = @user.errors.full_messages
      render 'new'
    end
  end

  def edit
    # empty method
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password)
  end

  def load_user
    @user = User.find(params[:id])
  end
end
