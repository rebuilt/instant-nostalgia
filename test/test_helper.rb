ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_user(username = 'me', password = '12345678')
    email = "#{username}@mail.com"
    user = User.new(email: email, password: password, username: username)
    user.save
    user
  end

  def create_album(user, title = 'first album')
    album = Album.new(user: user, title: title)
    album.save
    album
  end

  def create_photo_with_attachment(user)
    image = fixture_file_upload(Rails.root.join('test', 'images', '20190731_125829.jpg'), 'image/jpg')
    photo = Photo.create(image: image, user: user)
    photo.init
    photo
  end

  def sign_in(user)
    visit new_session_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log in'
  end
end
