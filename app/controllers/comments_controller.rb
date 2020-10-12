class CommentsController < ApplicationController
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(allowed_params)
    @comment.commentable = @commentable
    @comment.user = current_user
    # unsuccessful attempt to load rich text on ajax requests
    # files:  create.js.erb, comments.js, comments_controller#create
    # @body = @comment.body.body.as_json
    # @body = @comment.body.body.to_html
    # @body = @comment.body.to_plain_text
    puts @body
    if @comment.save
      @count = count(@commentable.comments.count)
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js { render :create }
      end
    else
      redirect_to @commentable, notice: 'could not save comment'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if is_owner?(current_user, @comment)
    @count = count(@commentable.comments.count)
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.js { render :destroy }
    end
  end

  private

  def allowed_params
    params.require(:comment).permit(:body, :user_id, :commentable_id)
  end

  def load_commentable
    resource, id = request.path.split('/')[2, 3]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def count(num)
    "#{num} #{'comment'.pluralize(num)}"
  end
end
