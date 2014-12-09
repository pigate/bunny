class StaticPagesController < ApplicationController
  def home
  end

  def about
  end
  def help
  end
  def vision
  end

  def recipe_search
    @recipe_results = Recipe.search(params[:search])
  end

  def suggestion_added
  end

  def not_found
  end
end
