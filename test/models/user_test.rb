require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'can save user if email and password and username are present' do
    user = User.new
    user.email = 'me@mail.com'
    user.password = '123'
    user.username = 'test'
    assert user.save
  end

  test 'user without email cannot save' do
    user = User.new
    user.password = '123'
    user.username = 'me'
    assert_not user.save
  end

  test 'user without username cannot save' do
    user = User.new
    user.password = '123'
    user.email = 'me@mail.com'
    assert_not user.save
  end

  test 'user without password cannot save' do
    user = User.new
    user.username = '123'
    user.email = 'me@mail.com'
    assert_not user.save
  end

  test 'email must be unique' do
    User.create(email: 'me@mail.com', username: 'me', password: '1')
    user = User.new(email: 'Me@mail.com', username: 'you', password: '1')
    assert_not user.save
  end

  test 'username must be unique' do
    User.create(email: 'you@mail.com', username: 'me', password: '1')
    user = User.new(email: 'Me@mail.com', username: 'me', password: '1')
    assert_not user.save
  end
end
