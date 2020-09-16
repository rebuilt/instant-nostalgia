require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  test 'Create a new share' do
    user = User.create(email: 'me@mail.com', password: '12345678', username: 'me')
    user2 = User.create(email: 'you@mail.com', password: '12345678', username: 'you')
    album = Album.new(title: 'first', user: user)
    share = Share.new(user: user2, album: album)
    assert share.save
  end

  test 'Share must have user' do
    user = User.create(email: 'me@mail.com', password: '12345678', username: 'me')
    album = Album.new(title: 'first', user: user)
    share = Share.new(album: album)
    assert_not share.save
  end

  test 'Share must have album' do
    user = User.create(email: 'me@mail.com', password: '12345678', username: 'me')
    share = Share.new(user: user)
    assert_not share.save
  end

  test 'Access shares' do
    user = User.create(email: 'me@mail.com', password: '12345678', username: 'me')
    user2 = create_user('you')
    user3 = create_user('him')
    user4 = create_user('her')
    user5 = create_user('it')
    album = Album.new(title: 'first', user: user)
    share = Share.new(user: user2, album: album)
    assert share.save
    Share.create(user: user3, album: album)
    Share.create(user: user4, album: album)
    Share.create(user: user5, album: album)
    album2 = Album.create(title: 'second', user: user)
    Share.create(user: user2, album: album2)

    # List users who are authorized to see album
    shares = album.shares
    shares.each do |s|
      puts s.user.email
    end
    assert_equal user2, shares.first.user

    # Alternate way to list users who are authorized to see album
    shares = Share.where(album: album)
    shares.each do |s|
      puts s.user.email
    end
    assert_equal user2, shares.first.user

    # Alternate way to list users who are authorized to see album
    people = album.users
    people.each do |person|
      puts person
    end
    assert_equal user2, people.first

    # Find everything shared with user2
    shares = Share.where(user: user2)
    shares.each do |s|
      puts s.album.title
    end
    assert_equal album, shares.first.album

    # Alternate method for finding everything shared with user2
    shares = user2.shares
    shares.each do |s|
      puts s.album.title
    end
    assert_equal album, shares.first.album

    # Alternate method for finding everything shared with user2
    albums = user2.authorized_albums
    albums.each do |a|
      puts a.title
    end
    assert_equal album, albums.first
  end
end
