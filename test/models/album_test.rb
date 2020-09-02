require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'user can save album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first')
    user.albums << album
    user.save
  end

  test 'can save a photo to an album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first')
    user.albums << album
    photo = Photo.new
    album.photos << photo
    album.save
  end
  test 'can only add a photo once to an album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first')
    user.albums << album
    photo = Photo.new(file_name: 'abc.jpg', user: user)
    album.photos << photo
    album.validate
    puts album.errors.full_messages
    puts photo.errors.full_messages
    assert album.save
  end
end
