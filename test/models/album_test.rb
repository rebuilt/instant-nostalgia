require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'user can save album' do
    user = User.new(email: 'me@mail.com', username: 'me', password: '123')
    album = Album.new(title: 'first')
    user.albums << album
    user.save
  end
end
