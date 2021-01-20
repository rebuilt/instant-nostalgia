include Pagy::Frontend

module ApplicationHelper
  def can_edit_user?(user)
    logged_in? && current_user == user
  end
end
