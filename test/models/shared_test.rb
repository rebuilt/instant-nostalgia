require 'test_helper'

class SharedTest < ActiveSupport::TestCase
  test 'can save user if email and password and username are present' do
    user = User.create(email: 'me@mail.com', password: '123', username: 'me')
    user2 = User.create(email: 'you@mail.com', password: '123', username: 'you')
    album = Album.new(title: 'first', user: user)
    user.albums << album
    assert user.save
    album.shares << user2
    assert album.save
  end
end
