class StaticPagesController < ApplicationController
  include MembersHelper
  include RecipesHelper #for add_to_analysis(...)

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
    @recipes = []
    if (params[:search].present?)
      tags = Tag.all
      tokenized_tags = params[:search].split(' ')
      tag_columns = tags.select { |e| tokenized_tags.include? e.name }
      tag_columns.each do |t|
       @recipes += t.recipes
      end
      @recipes = @recipes.uniq
      #TODO user analysis
      #columns = TagHits.columns.map {|c| c.name}
      #base_columns = columns.select { |i| !i.match(/percent$/) && i.match(/count$/) }
      #add_to_analysis(params[:search].split(' '), 2)
    else
      @recipes = []
    end
  end

  def post_search
    if (params[:search].present?)
      @posts = [] #Post.search(params[:search]).records.to_a
    else
      @posts = Post.all.reverse
      respond_with(@posts)
    end
  end

  def member_search
    if (params[:search].present?)
      token = params[:search]
      @members = []
      @members += Member.where('user_name LIKE ?', "%"+token + "%")
      @members += Member.where('email LIKE ?', "%"+token+"%")
      @members = @members.uniq
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
    if (params[:search].present?)
      @groups = Group.where('name LIKE ?', "%"+params[:search]+"%") #the percentages are postgres wildcards. O/w can do without but will exact match
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
      @starred_list = StarredRecipeList.find_by_member_id(current_member.id).saved_recipes_array.split(",").map { |e| e.to_i }
      make_recommendation(current_member)
      rec_list = Recommendations.find_by_member_id(current_member.id).recs_list.split(',').map { |e| e.to_i }
      @recommended = []
      rec_list.each do |r|
        @recommended.push(Recipe.find(r))
      end
      @recent = []
      begin
        @list = current_member.recently_viewed_recipes.recently_viewed_list.split(",").map {|e| e.to_i }
        @list.each do |l|
          @recent.push(Recipe.find(l))
        end
      rescue
        logger.debug "StaticPages#box **Fatal: Could not find Member(#{current_member.id}).recently_viewed_recipes"
      end
    end
  end


end
