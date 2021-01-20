include Pagy::Backend

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  helper_method :logged_in?, :current_user, :ensure_logged_in, :is_owner?, :can_view_photo?, :can_view_album?
  add_flash_types :success

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def logged_in?
    # session[:user_id].destroy unless User.exists?(session[:user_id])
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def ensure_logged_in
    redirect_to login_path unless logged_in?
  end

  def is_owner?(user, model)
    user == model.user
  end

  def can_view_photo?(photo)
    # Can view the photo if it's public
    photo.albums.each do |album|
      return true if album.public
    end

    # Can view the photo if it's been shared with them
    photo.authorized_users.each do |user|
      return true if logged_in? && current_user == user
    end

    # Can view the photo if it belongs to them
    return true if logged_in? && current_user == photo.user

    false
  end

  def can_view_album?(album)
    return true if album.public

    logged_in? && (current_user == album.user || current_user.authorized_albums.include?(album))
  end

  def can_destroy(share)
    current_user == share.album.user || current_user.id == share.user_id
  end
end
