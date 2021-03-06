class GroupsController < ApplicationController
  include NewsFeedHelper

  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :signed_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @groups = Group.all
    if (params[:search].present?)
      @groups = Group.where('name LIKE ?', "%"+params[:search]+"%") #the percentages are postgres wildcards. O/w can do without but will exact match
    else
      @groups = Group.all.reverse
      respond_with(@groups)
    end
  end

  def show
    respond_with(@group)
  end

  def new
    @group = Group.new
    respond_with(@group)
  end

#  def edit
#  end

  def create
    @group = Group.new(group_params)
    if @group.save
      xml_builder = ::Builder::XmlMarkup.new
      mass_str = xml_builder.p { |xml|
        xml.a(current_member.user_name, 'href' => member_path(current_member))
        xml.em(" just created the group ")
        xml.a(@group.name, 'href' => group_path(@group))
      }
      mass_feed_push(current_member.id, mass_str)
    end
    respond_with(@group)
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }     
      end
    end
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:owner_id, :name, :description)
  end
  def signed_in
    if !member_signed_in?
      redirect_to login_path
    end
  end
  def can_edit
    if !(current_member.id == @group.owner_id || current_member.admin == true)
      redirect_to not_found_path
    end
  end

end
