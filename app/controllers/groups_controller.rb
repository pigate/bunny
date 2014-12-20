class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :signed_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  respond_to :html

#  def index
#    @groups = Group.all
#    if (params[:search].present?)
#      @groups = Group.search(params[:search]).records.to_a
#    else
#      @groups = Group.all.reverse
#      respond_with(@groups)
#    end
#  end

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
      redirect_to members_login_path
    end
  end
  def can_edit
    if !(current_member.id == @group.owner_id || current_member.admin == true)
      redirect_to not_found_path
    end
  end

end
