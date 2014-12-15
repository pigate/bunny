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

  def going_ons
   @activities = nil
  end

  def box
    if !member_signed_in?
    else
      @recommended = Recipe.where(:author_id != current_member.id, :limit => 25)
    end
  end

end
