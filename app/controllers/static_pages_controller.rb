class StaticPagesController < ApplicationController
  include MembersHelper

  def home
  end

  def about
  end

  def help
  end

  def vision
  end

  def community
    @groups = Group.last(4)
    @members = Member.last(8).reverse
  end

  def recipe_search
    if (params[:search_params].present?)
      @recipes = Recipe.search(params[:search_params]).records.to_a
    else
      @recipes = []
    end
  end

  def post_search
    if (params[:search_params].present?)
      @posts = Post.search(params[:search_params]).records.to_a
    else
      @posts = []
    end

  end

  def member_search
    if (params[:search_params].present?)
      @members = Member.search(params[:search_params]).records.to_a
    else
      @members = []
    end
  end

  def generic_search
      @tags = ["whatsfordinner", "whatsforlunch", "lazycat", "nomnom", "Chinese"]
      @recipes = Recipe.last(8)
      @posts = Post.last(4)
      @groups = Group.last(4)
      @members = Member.last(8).reverse
  end

  def group_search
    if (params[:search_params].present?)
      @groups = Group.search(params[:search_params]).records.to_a
    else
      @groups = []
    end
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
      make_recommendation(current_member)
      rec_list = Recommendations.find_by_member_id(current_member.id).recs_list.split(',').map { |e| e.to_i }
      @recommended = []
      rec_list.each do |r|
        @recommended.push(Recipe.find(r))
      end
      @recent = []
      @list = current_member.recently_viewed_recipes.recently_viewed_list.split(",").map {|e| e.to_i }
      @list.each do |l|
        @recent.push(Recipe.find(l))
      end
    end
  end


end
