require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'can add photo to multiple albums' do
    user = User.new(email: 'me@mail.com', password: '123', username: 'me')
    photo = Photo.new(user: user)
    album = Album.new(title: 'first', user: user)
    album.photos << photo
    assert album.save
    second_album = Album.new(title: 'another', user: user)
    second_album.photos << photo
    assert second_album.save
  end

  test 'photo must have user assigned' do
    photo = Photo.new
    assert_not photo.save
  end
end
