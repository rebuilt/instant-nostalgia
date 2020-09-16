require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'can save user if email and password and username are present' do
    user = create_user(username: 'me', password: '12345678', email: 'me@mail.com')
    assert user.save
  end

  test 'save fails if password is too short' do
    user = User.new(username: 'me', password: '1234567', email: 'me@mail.com')
    assert_not user.save
  end

  test 'user without email cannot save' do
    user = User.new
    user.password = '12345678'
    user.username = 'me'
    assert_not user.save
  end

  test 'user without username cannot save' do
    user = User.new
    user.password = '12345678'
    user.email = 'me@mail.com'
    assert_not user.save
  end

  test 'user without password cannot save' do
    user = User.new
    user.username = '12345678'
    user.email = 'me@mail.com'
    assert_not user.save
  end

  test 'email must be unique' do
    User.create(email: 'me@mail.com', username: 'me', password: '12345678')
    user = User.new(email: 'Me@mail.com', username: 'you', password: '12345678')
    assert_not user.save
  end

  test 'username must be unique' do
    User.create(email: 'you@mail.com', username: 'me', password: '12345678')
    user = User.new(email: 'Me@mail.com', username: 'me', password: '12345678')
    assert_not user.save
  end
end
