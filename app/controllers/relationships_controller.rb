class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:destroy]

  before_action :signed_in, only: [:create, :destroy]
  #POST /relationships
  #POST /relationships.json
  def index
    redirect_to not_found_path
  end
  def new
    @relationship = Relationship.new
  end
  
  def create
    @relationship = Relationship.new(relationship_params)
    respond_to do |format|
      if @relationship.save
        @member = Member.find(@relationship.followed_id)
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        format.js
        #render :json { :success => false }
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
        #render :json { :success => false }
      end
    end
  end

  def destroy
    @member = Member.find(@relationship.followed_id)
    if @relationship.destroy
      respond_to do |format|
        format.html {} 
        format.js
      end
    end
  end
  private
    def set_relationship
      @relationship = Relationship.find(params[:id])
      redirect_to not_found_path unless @relationship
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit(:follower_id, :followed_id)
    end


  def signed_in  
    if !member_signed_in?
      render :js => "window.location.replace('#{new_member_session_path}');"
    end
  end
end
