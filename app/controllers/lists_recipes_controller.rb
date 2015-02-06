class ListsRecipesController < ApplicationController
  before_action :is_signed_in, only: [:create, :update, :destroy]

  def create
    @list_recipe = ListsRecipes.new(lists_recipes_params)
    @dupe = false
    @list_not_found = false
    respond_to do |format|
      begin
        if @list_recipe.save
          @list = List.find(lists_recipes_params[:list_id])
          @array = @list.recipe_order_array.split(',')
          @array.push(lists_recipes_params[:recipe_id].to_s)
          @list.update_attributes(:recipe_order_array => @array.join(','))
        end
      rescue ActiveRecord::RecordNotUnique => e
        @dupe = true
        logger.debug("ListsRecipesController: RecordNotUnique")
      rescue ActiveRecord::RecordNotFound => e
        @list_not_found = true
        logger.debug("ListsRecipesController: List not found")
      end
      format.js
    end
  end

  def update
    @list_recipe.update(lists_recipes_params)
  end

  def destroy
    @list_recipe = ListsRecipes.find_by_list_id(params[:list_id]).destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def set_lists_recipes
    @list_recipe = ListsRecipes.find(params[:id])
  end

  def lists_recipes_params
    params.require(:lists_recipes_param).permit(:list_id, :recipe_id)
  end

  def is_signed_in
    if !member_signed_in?
      redirect_to login_path
    end
  end
end

