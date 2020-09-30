ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_user(username = 'me', password = '12345678')
    email = "#{username}@mail.com"
    User.create(email: email, password: password, username: username)
  end

  def create_album(user, title = 'first album')
    Album.create(user: user, title: title)
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

  def create_photo(index, user)
    case index

    when 0
      photo = Photo.create(
        file_name: '20190110_121035.jpg',
        latitude_in_degrees: '46/1, 30/1,19434/10000, N',
        latitude_in_decimal: 46.500539833333335,
        longitude_in_degrees: '6/1, 53/1, 196739/10000, E',
        longitude_in_decimal: 6.8887983055555555,
        city: 'Saint-Légier-La Chiésaz',
        state: 'Vaud',
        state_code: 'Vaud',
        postal_code: '1806',
        country: 'Switzerland',
        country_code: 'ch',
        date_time_digitized: '2019-01-10 12:10:35',
        user: user
      )
    when 1
      photo = Photo.create(
        file_name: '20190720_112806.jpg',
        latitude_in_degrees: '46/1, 23/1, 416780/10000, N',
        latitude_in_decimal: 46.394910555555555,
        longitude_in_degrees: '6/1, 54/1, 357286/10000, E',
        longitude_in_decimal: 6.909924611111111,
        city: 'Noville',
        state: 'Vaud',
        state_code: 'Vaud',
        postal_code: '1845',
        country: 'Switzerland',
        country_code: 'ch',
        date_time_digitized: '2019-07-20 11:28:06',
        user: user
      )
    end
    image = fixture_file_upload(Rails.root.join('test', 'images', '20170827_093118.jpg'), 'image/jpg')
    photo.image = image
    photo.save
    photo
  end
end
