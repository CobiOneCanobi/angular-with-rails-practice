class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :upvote]
  def index
    respond_with Post.all
  end

  def create
    respond_with Post.create(post_params.merge(user_id: current_user.id))
  end

  def show
    respond_with Post.find(params[:id])
  end

  def upvote
    post = Post.find(params[:id])
    upvote = Upvote.where(user_id: current_user.id, post_id: post.id)
    if upvote == []
      post.increment!(:upvotes)
      Upvote.create(user_id: current_user.id, post_id: post.id)
      respond_with post
    else
      render json: { error: 1}
    end
  end

  private
  def post_params
    params.require(:post).permit(:link, :title)
  end

end
