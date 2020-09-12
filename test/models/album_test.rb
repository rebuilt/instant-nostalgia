require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'user can save album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first')
    user.albums << album
    assert user.save
  end

  test 'can save a photo to an album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first', user: user)
    photo = Photo.new(user: user)
    album.photos << photo
    assert album.save
  end

  test 'can many photos to an album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    user2 = User.new(email: 'me2@mail.com', username: 'me2', password: '123')
    album = Album.new(title: 'first', user: user)
    photo = Photo.new(user: user)
    photo2 = Photo.new(user: user2)
    album.photos << photo
    album.photos << photo2
    assert album.save
  end

  test 'album must have a title' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(user: user)
    user.albums << album
    photo = Photo.new(user: user)
    album.photos << photo
    assert_not album.save
  end

  test 'album must be assigned user' do
    album = Album.new
    assert_not album.save
  end
end
