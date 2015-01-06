class RecipesController < ApplicationController
  include NewsFeedHelper
  include RecipesHelper
 
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :is_signed_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :can_destroy, only: [:edit, :update, :destroy]

  respond_to :html, :json

  @@n = 10 #max number recipes to keep on list

  def index
    @tag_types = TagType.all
    if (params[:search].present?)
      @recipes = Recipe.search(params[:search]).records.to_a
      #TODO need to replace above line with join of results from actual filter searches, combined with recs, and more relevant search results
      columns = TagHits.columns.map {|c| c.name}
      base_columns = columns.select { |i| !i.match(/percent$/) && i.match(/count$/) }
      #user_analytics
      #for each filter chosen, if member_signed_in, increment tag_hit 
      add_to_analysis(params[:search].split(' '), 2)
    else
      @recipes = Recipe.all.reverse
      respond_with(@recipes.reverse)
    end
  end

  def show 
    #increment recipe's global view count
    @global_count = @recipe.global_views + 1
    @recipe.update_attributes(:global_views => @global_count)
    if member_signed_in?
      #update recently_viewed_recipes
      row = RecentlyViewedRecipes.find_by_member_id(current_member.id)
      str_list = row.recently_viewed_list
      arr = str_list.split(',')
      #check if recipe already in recently viewed
      element_index = arr.index(@recipe.id.to_s)
      if arr.length >= @@n && @@n > 0
        #get first n-1 slice
        if !element_index
          arr = arr[0, @@n-1]
        else
          arr = arr[0, @@n]
        end
      end
      if element_index != nil 
        #recipe already included in list. pull to forefront
        arr.delete_at(element_index)
      end
      #add recipe to forefront
      arr = [@recipe.id.to_s] + arr
      row.update_attributes("recently_viewed_list" => arr.join(','))
      #analytics
      tags = destringify(@recipe.s_tags)["tags"]
      add_to_analysis(tags, 2)      
    end
    respond_with(@recipe)
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      @recipe.convo = Convo.new(:owner_id => current_member.id)
      #TODO news_feed current_member's followers
      xml_builder = ::Builder::XmlMarkup.new
      str = xml_builder.p { |xml|
        xml.a(current_member.user_name, 'href' => member_path(current_member))
        xml.em(" just created a new recipe! ")
        xml.a(@recipe.name, 'href' => recipe_path(@recipe))
      }
      Rails.logger.debug("from recipe controller NewsFeedsWorker/Recipe Creation start. Trying to input the following string to user's followers feeds: "+str)
      mass_feed_push(current_member.id, str)
      #MassFeedWorker.perform_async(current_member.id, str)
      index_recipe(@recipe)
      tags = destringify(@recipe.s_tags)["tags"]
      add_to_analysis(tags, 2)
      respond_with(@recipe)
    else
      render json: {status: "fail" }
    end
  end

  def update
    if is_signed_in
      @recipe.update(recipe_params)
      index_recipe(@recipe)
      respond_with(@recipe)
    elsif !can_destroy
      raise Exceptions::NotAuthorizedError
    end
  end

  def destroy
    @recipe.destroy
    respond_with(@recipe)
  end

  private

    def set_recipe
      actual_id = /[0-9]+$/.match(params[:id]) #returns a MatchData type
      @recipe = Recipe.find_by_id(actual_id[0]) 
      redirect_to not_found_path unless @recipe      
    end

    def recipe_params
      params.require(:recipe).permit(:name, :about, :ingreds, :j_ingreds, :steps, :j_steps, :author_id, :prep_time, :cook_time, :servings, :main_photo, :s_tags)
    end
    def is_signed_in
     current_member != nil
    end
    def can_destroy
      current_member.admin || current_member.id == @recipe.author_id
    end

  def index_recipe(recipe)
    #need to create recipes_tags model file to access table like this
    RecipesTags.where(:recipe_id => recipe.id).destroy_all
    obj = JSON.parse(recipe.s_tags)
    obj["tags"].each do |tag|
      t = Tag.find_by_name(tag)
      if t != nil
        recipe.tags.push(t)
      end
    end
  end

end
