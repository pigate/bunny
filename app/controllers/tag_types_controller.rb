class TagTypesController < ApplicationController
  before_action :set_tag_type, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:edit, :new, :update, :destroy, :create]
  respond_to :html

  def index
    @tag_types = TagType.all
    respond_with(@tag_types)
  end

  def show
    respond_with(@tag_type)
  end

  def new
    if member_signed_in? && current_member.admin
      @tag_type = TagType.new
      respond_with(@tag_type)
    else
      redirect_to root_url
    end
  end

  def edit
    if !member_signed_in? || current_member.admin == false
      redirect_to root_url
    end
  end

  def create
    if member_signed_in? && current_member.admin
      @tag_type = TagType.new(tag_type_params)  
      @tag_type.save
      respond_with(@tag_type)
    else
      redirect_to root_url
    end
  end

  def update
    if member_signed_in? && current_member.admin
      @tag_type.update(tag_type_params)
      respond_with(@tag_type)
    else
      redirect_to root_url
    end
  end

  def destroy
    if member_signed_in? && current_member.admin
      @tag_type.destroy
      respond_with(@tag_type)
    else
      redirect_to root_url
    end
  end

  private
    def set_tag_type
      @tag_type = TagType.find(params[:id])
    end

    def tag_type_params
      params.require(:tag_type).permit(:name, :description)
    end

    def check_admin
      if !(member_signed_in? && current_member.admin)
        redirect_to root_url
      end
    end
end
