class CommentsController < ApplicationController
  def create
    photo = Photo.find(params[:photo_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.photo = photo
    @comment.save
    redirect_to photo_path(photo)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
