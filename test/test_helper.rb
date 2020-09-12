ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_user(username = 'me', password = '123')
    email ||= "#{username}@mail.com"
    User.create(email: email, password: password, username: username)
  end

  def create_photo_with_attachment(user)
    image = fixture_file_upload(Rails.root.join('test', 'images', '20190731_125829.jpg'), 'image/jpg')
    photo = Photo.create(image: image, user: user)
    photo.init
    photo
  end
end
