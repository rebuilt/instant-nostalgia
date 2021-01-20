module SharesHelper
  def remove_current_user(users)
    # don't include self in list of users to share with
    users.reject { |user| user == current_user }
  end

  def remove_already_authorized_users(album, users)
    # don't include users that already have access to the album
    album.users.each do |already_authorized_user|
      users = users.reject { |user| user == already_authorized_user }
    end
    users
  end
end
