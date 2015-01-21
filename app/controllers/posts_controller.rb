class PostsController < ApplicationController
  include NewsFeedHelper

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :signed_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @posts = Post.all
    if (params[:search].present?)
      @posts = [] #Post.search(params[:search]).records.to_a
    else
      @posts = Post.all.reverse
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
      json_tags = post_params[:s_tags]
      if json_tags != '' && json_tags != nil
        json_object = JSON.parse(json_tags)
        json_groups = json_object["groups"]
        group_array_ids = json_groups.split(',')

        group_array_ids.each do |id|
          @post.group_posts.build(:group_id => id).save
        end
      end
      @post.convo = Convo.new(:conversable_id => @post.id, :conversable_type => "Post", :owner_id => current_member.id)
    end
    respond_with(@post)
  end

  def update
    if @post.update(post_params)
      respond_with(@post)
       @post.group_posts.destroy_all
       json_tags = post_params[:s_tags]
       if json_tags != '' && json_tags != nil
          json_object = JSON.parse(json_tags)
          json_groups = json_object["groups"]
          group_array_ids = json_groups.split(',')

          group_array_ids.each do |id|
            @post.group_posts.build(:group_id => id).save
          end
      end
    end
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
      redirect_to login_path
    end
  end
  def can_edit
    if !(current_member.id == @post.author_id || current_member.admin == true)
      redirect_to not_found_path
    end
  end

end
