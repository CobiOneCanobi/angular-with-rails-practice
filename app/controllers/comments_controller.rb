class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :upvote]

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with post, comment
  end

  def upvote
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    upvote = Upvote.where(user_id: current_user.id, comment_id: comment.id)
    if upvote == []
      comment.increment!(:upvotes)
      Upvote.create(user_id: current_user.id, comment_id: comment.id)
      respond_with post, comment
    else
      render json: { error: 1}
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end