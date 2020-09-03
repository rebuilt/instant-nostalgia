require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  test 'Create a new share' do
    user = User.create(email: 'me@mail.com', password: '123', username: 'me')
    user2 = User.create(email: 'you@mail.com', password: '123', username: 'you')
    album = Album.new(title: 'first', user: user)
    share = Share.new(user: user2, album: album)
    assert share.save
    assert_equal share.album, Share.where(album: album.id)
  end
end
