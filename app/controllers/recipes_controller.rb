class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @tag_types = TagType.all
    if (params[:search].present?)
      @recipes = Recipe.search(params[:search]).records.to_a
    else
      @recipes = Recipe.all
      respond_with(@recipes)
    end
  end

  def show
    respond_with(@recipe)
  end

  def new
    if is_signed_in
      @recipe = Recipe.new
      respond_with(@recipe)
    else
       raise Exceptions::AuthenticationError 
    end
  end

  def edit
    if !is_signed_in 
      redirect_to members_login_path
    elsif !can_destroy
      raise Exceptions::NotAuthorizedError
    end
  end

  def create
    if is_signed_in
      @recipe = Recipe.new(recipe_params)
      @recipe.save
      respond_with(@recipe)
    else
      raise Exceptions::AuthenticationError
    end
  end

  def update
    if is_signed_in
      @recipe.update(recipe_params)
      respond_with(@recipe)
    elsif !can_destroy
      raise Exceptions::NotAuthorizedError
    end
  end

  def destroy
    if is_signed_in && can_destroy
      @recipe.destroy
      respond_with(@recipe)
    else
      raise Exceptions::NotAuthorizedError
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(:name, :about, :ingreds, :j_ingreds, :steps, :j_steps, :author_id)
    end
    def is_signed_in
     current_member != nil
    end
    def can_destroy
      current_member.admin || current_member.id == Recipe.find(params[:id]).author_id
    end
end
