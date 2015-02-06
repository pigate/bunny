class ListsController < ApplicationController
  before_action :signed_in, only: [:create, :destroy]
  before_action :set_list, only: [:destroy]
  before_action :matches_id, only: [:destroy]
  def create
    @list = List.new(list_params)
    @errors = nil
    respond_to do |format|
      begin
       @list.save
      rescue ActiveRecord::RecordNotUnique
        @errors = ["Please enter a unique name"]
      end
      format.js
    end
  end

  def show

  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:list_id, :owner_id, :recipe_order_array, :private, :description, :name)
  end
  def signed_in
    if !member_signed_in?
      render :js => "window.location.replace('#{login_path}');"
    end
  end
  def matches_id
    @list.owner_id == current_member.id
  end
end

