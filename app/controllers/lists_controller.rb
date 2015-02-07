class ListsController < ApplicationController
  before_action :signed_in, only: [:create, :destroy]
  before_action :set_list, only: [:destroy]
  before_action :matches_id, only: [:destroy]
  
  def index
    @m = Member.find_by_user_name(params[:member_id])
    @lists = List.where('owner_id' => @m.id)
	@recipes_in_lists = []
	curr_array = nil 
	@starred_list = StarredRecipeList.find_by_member_id(@m.id).saved_recipes_array.split(',').map { |e| e.to_i }
	@starred = []
	@starred_list.each do |r|
	  begin
	    @starred.push(Recipe.find(r))
	  rescue
	    logger.debug("ListsController: Could not find starred recipe with id <%= r %>")
	  end
	end
	
	
	@lists.each do |l|
	  #fetch recipes 
	  curr_array = []
	  recipe_ids = l.recipe_order_array.split(',').map { |e| e.to_i }
	  recipe_ids.each do |rid|
	    begin
          curr_array.push(Recipe.find(rid))		
		rescue 
		  logger.debug("ListsController: Could not find Recipe with id: #{rid}")
		end
	  end
	  @recipes_in_lists.push(curr_array)
	end 
  end
  
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

