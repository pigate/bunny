class CommentsController < ApplicationController
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
      render :js => "window.location.replace('#{new_member_session_path}');"
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
