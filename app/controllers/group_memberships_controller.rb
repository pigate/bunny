class GroupMembershipsController < ApplicationController
  before_action :set_group_membership, only: [:destroy]

  before_action :signed_in, only: [:create, :destroy]
  #POST /group_memberships
  #POST /group_memberships.json
  
  def create
    @group_membership = GroupMembership.new(group_membership_params)
    respond_to do |format|
      if @group_membership.save
        @group = @group_membership.joined_group

        xml_builder = ::Builder::XmlMarkup.new
        mass_str = xml_builder.p { |xml|
          xml.a(current_member.user_name, 'href' => member_path(current_member))
          xml.em(" became a new member of ")
          xml.a(@group.name, 'href' => group_path(@group))
        }
        if @group.owner
          Rails.logger.debug("ExceptFeedWorker from group_membership#create: "+mass_str)
          #ExceptFeedWorker.perform_async(current_member.id, mass_str, @group.owner.id)

          xml_builder = ::Builder::XmlMarkup.new
          single_str = xml_builder.p { |xml|
            xml.a(current_member.user_name, 'href' => member_path(current_member))
            xml.em(" just joined your group ")
            xml.a(@group.name, 'href' => group_path(@group))
          }
          #SingleFeedWorker.perform_async(@target.id, @group.owner.id)
        else
          #MassFeedWorker.perform_async(current_member.id, mass_str)
        end

        format.js
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        #render :json { :success => false }
        format.html { redirect_to @group }
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
        #render :json { :success => false }
      end
    end
  end

  def destroy
    @group = @group_membership.joined_group
    if @group_membership.destroy
      respond_to do |format|
        format.js
        format.html { redirect_to @group } 
        format.json { render :json => { :status => "ok", :message => 'ok' } }
      end
    end
  end
  private
    def set_group_membership
      @group_membership = GroupMembership.find(params[:id])
      redirect_to not_found_path unless @group_membership
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_membership_params
      params.require(:group_membership).permit(:joined_group_id, :member_id)
    end


  def signed_in  
    if !member_signed_in?
      render :js => "window.location.replace('#{login_session_path}');"
    end
  end
end
