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
    @target = Member.find(@relationship.followed_id)
    respond_to do |format|
      if @relationship.save
        @member = Member.find(@relationship.followed_id)
        xml_builder = ::Builder::XmlMarkup.new
        mass_str = xml_builder.p { |xml|
          xml.a(current_member.user_name, 'href' => member_path(current_member))
          xml.em(" just followed ")
          xml.a(@target.user_name, 'href' => member_path(@target))
        }
        Rails.logger.debug("from relationships controller start. Trying to input the following string to user's followers feeds: "+mass_str)
        ExceptFeedWorker.perform_async(current_member.id, mass_str, @target.id)
        xml_builder = ::Builder::XmlMarkup.new
        single_str = xml_builder.p { |xml|
          xml.a(current_member.user_name, 'href' => member_path(current_member))
          xml.em(" just followed you!")
        }
        SingleFeedWorker.perform_async(@target.id, single_str)

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
      render :js => "window.location.replace('#{login_path}');"
    end
  end
end
