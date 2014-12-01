class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def vision
  end

  def recipe_search
    @recipe_results = Recipe.search(params[:search])
  end
end
