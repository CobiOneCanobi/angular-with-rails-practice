class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :upvote]
  def index
    posts = Post.all
    upvotes = Upvote.where(user_id: current_user.id)
    response = {posts: posts, upvotes: upvotes}
    respond_with response
  end

  def create
    respond_with Post.create(post_params.merge(user_id: current_user.id).merge(viewed: 0).merge(upvotes: 0))
  end

  def show
    post = Post.find(params[:id])
    post.increment!(:viewed)
    respond_with post
  end

  def upvote
    post = Post.find(params[:id])
    upvote = Upvote.where(user_id: current_user.id, post_id: post.id)
    if upvote == []
      post.increment!(:upvotes)
      Upvote.create(user_id: current_user.id, post_id: post.id)
      respond_with post
    else
      upvote.delete_all
      render json: { upvoted: 1}
    end
  end

  private
  def post_params
    params.require(:post).permit(:link, :title, :body)
  end

end
