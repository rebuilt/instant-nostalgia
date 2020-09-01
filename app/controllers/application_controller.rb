class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  helper_method :logged_in?, :current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
