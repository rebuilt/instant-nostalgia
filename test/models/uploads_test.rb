require 'test_helper'
include ActionDispatch::TestProcess

class UploadsTest < ActiveSupport::TestCase
  test 'upload a file' do
    count = ActiveStorage::Attachment.count
    image = fixture_file_upload(Rails.root.join('public', 'images', '20170827_093118.jpg'), 'image/jpg')

    user = User.new
    photo = Photo.create(image: image, user: user)
    assert_equal ActiveStorage::Attachment.count, count + 1
    metadata = photo.read_image_metadata
    photo.populate_with(metadata)
    photo.initialize_latlong_decimals
    assert_equal 0, photo.latitude_in_decimal
    assert_equal 0, photo.longitude_in_decimal
    assert_equal '0', photo.latitude_in_degrees
    assert_equal '0', photo.longitude_in_degrees
    assert_equal '20170827_093118.jpg', photo.file_name

    count = ActiveStorage::Attachment.count
    image = fixture_file_upload(Rails.root.join('public', 'images', '20190731_125829.jpg'), 'image/jpg')

    user = User.new
    photo = Photo.create(image: image, user: user)
    assert_equal ActiveStorage::Attachment.count, count + 1
    metadata = photo.read_image_metadata
    photo.populate_with(metadata)
    photo.initialize_latlong_decimals
    assert_in_delta 46.41853, photo.latitude_in_decimal, 0.01
    assert_in_delta 6.95111, photo.longitude_in_decimal, 0.01
    assert_equal '46/1, 25/1, 67229/10000, N', photo.latitude_in_degrees
    assert_equal '6/1, 57/1, 40169/10000, E', photo.longitude_in_degrees
    assert_equal '20190731_125829.jpg', photo.file_name
  end
end
