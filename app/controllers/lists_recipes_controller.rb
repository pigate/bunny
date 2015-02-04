class ListsRecipesController < ApplicationController
  def create
    @list_recipe = ListsRecipes.new(lists_recipes_params)
    respond_to do |format|
      if @list_recipe.save
        format.js
      end
    end
  end

  def destroy
    @list_recipe = ListsRecipes.find_by_list_id(params[:list_id]).destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def lists_recipes_params
    params.require(:list_recipe).permit(:list_id, :recipe_id)
  end
end

