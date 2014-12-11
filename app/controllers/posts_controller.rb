class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :signed_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @posts = Post.all
    if (params[:search].present?)
      @posts = Post.search(params[:search]).records.to_a
    else
      @posts = Post.all
      respond_with(@posts)
    end
  end

  def show
    respond_with(@post)
  end

  def new
    @post = Post.new
    respond_with(@post)
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_member.id
    if @post.save
      @post.convo = Convo.new(:conversable_id => @post.id, :conversable_type => "Post", :owner_id => current_member.id)
    end
    respond_with(@post)
  end

  def update
    @post.update(post_params)
    respond_with(@post)
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:author_id, :post_text, :s_tags, :photo)
  end
  def signed_in
    if !member_signed_in?
      redirect_to members_login_path
    end
  end
  def can_edit
    if !(current_member.id == @post.author_id || current_member.admin == true)
      redirect_to not_found_path
    end
  end

end
