class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to maps_path
    else
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path
  end
end
