require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'can create comment on a photo' do
    user = create_user
    commentable = Photo.new(user: user)
    comment = commentable.comments.new
    comment.commentable = commentable
    comment.user = user
    assert comment.save
  end

  test 'comment cannot be over limited size' do
    user = create_user
    commentable = Photo.new(user: user)
    comment = commentable.comments.new
    comment.commentable = commentable
    comment.user = user
    comment.body = 'Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over 1000 characters long.  Over'
    assert_not comment.save
  end

  test 'small comments work' do
    user = create_user
    commentable = Photo.new(user: user)
    comment = commentable.comments.new
    comment.commentable = commentable
    comment.user = user
    comment.body = 'Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 characters.  Under 1000 character'
    comment.validate
    puts comment.errors.full_messages
    assert comment.save
  end

  test 'comment must have assigned user' do
    user = create_user
    commentable = Photo.new(user: user)
    comment = commentable.comments.new
    comment.commentable = commentable
    assert_not comment.save
  end

  test 'comment has implicit commentable set' do
    user = create_user
    commentable = Photo.new(user: user)
    comment = commentable.comments.new
    # this line is not needed since the above line implicitly sets commentable
    # comment.commentable = commentable
    comment.user = user
    assert comment.save
  end
end
