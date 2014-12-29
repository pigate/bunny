class CommentsController < ApplicationController
  include NewsFeedHelper

  before_action :set_comment, only: [:edit, :update, :destroy]

  before_action :signed_in, only: [:create, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :is_admin, only: [:index]
  #POST /comments
  #POST /comments.json
  def index
    redirect_to not_found_path
    @comments = Comment.all
  end
  def new
    @comment = Comment.new
  end
  
  def create
   
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        xml_builder = ::Builder::XmlMarkup.new
        single_str = ""
        convo = @comment.commentable 
        topic = convo.conversable
        type = convo.conversable_type
        if topic.author != current_member
          case convo.conversable_type
            when "Recipe"
            if topic.author 
              single_str = xml_builder.p { |xml|
                xml.a(current_member.user_name, 'href' => member_path(current_member))
                xml.em(" just commented on your Recipe! ") 
                xml.a(topic.name, 'href' => recipe_path(topic))
              }
              single_feed_push(topic.author.id, single_str)
              #SingleFeedWorker.perform_async(topic.author.id, single_str)
            end
            when "Post"
            if topic.author
              single_str = xml_builder.p { |xml|
                xml.a(current_member.user_name, 'href' => member_path(current_member))
                xml.em(" just commented on your") #post or recipe??
                xml.a("Post!", 'href' => post_path(topic))
              }
              single_feed_push(topic.author.id, single_str)
              #SingleFeedWorker.perform_async(topic.author.id, single_str)
            end
            when "Group"
            if topic.owner
              single_str = xml_builder.p { |xml|
                xml.a(current_member.user_name, 'href' => member_path(current_member))
                xml.em(" just commented on your ") #post or recipe??
                xml.a("group wall!", 'href' => group_path(topic))
              }
              single_feed_push(topic.author.id, single_str)
              #SingleFeedWorker.perform_async(topic.owner.id, single_str)
            end
          end
        end
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        format.js
        #render :json { :success => false }
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
        #render :json { :success => false }
      end
    end
  end
  #PATCH/PUT  /comments/1
  def update
    respond_to do |format|
      if current_member.try(:admin?) || current_member == @comment.commenter
        if @comment.update(comment_params)
          format.json { render :json => { :status => "ok", :message => 'ok' } }
          #render :json { :success => true }
        end
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
        #render :json { :success => false }
      end
    end
  end

  def destroy
    @convo = @comment.commentable
    if @comment.destroy
      respond_to do |format|
        format.html {} 
        format.js
      end
    end
  end
  private
    def set_comment
      @comment = Comment.find(params[:id])
      redirect_to not_found_path unless @comment
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:commentable_id, :commentable_type, :commenter_id, :comment_text)
    end


  def signed_in  
    if !member_signed_in?
      render :js => "window.location.replace('#{login_path}');"
    end
  end
  def can_edit
    if current_member.try(:id) == @comment.commenter_id || current_member.try(:admin)  
    else
      redirect_to root_url
    end
  end
  def is_admin
    current_member.try(:admin)
  end
end
