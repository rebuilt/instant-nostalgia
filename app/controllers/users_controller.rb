class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update destroy]
  before_action :authorized_to_edit, only: %i[edit update]
  before_action :authorized_to_destroy, only: %i[destroy]

  def show
    @private_albums = @user.albums.reject { |album| album.public == true }
    @public_albums = @user.albums.reject { |album| album.public == false }
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
    # empty method. Loads user through before_actions
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

  def destroy
    @user.destroy
    session.delete(:user_id)
    redirect_to login_path
  end

  private

  def authorized_to_edit
    redirect_to login_path unless current_user == @user
  end

  def authorized_to_destroy
    @user = User.find(params[:id])
    redirect_to login_path unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:avatar, :username, :first_name, :last_name, :email, :password, :password_confirmation)
  end

  def load_user
    @user = User.find(params[:id])
  end
end
