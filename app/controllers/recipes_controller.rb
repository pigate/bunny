class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @tag_types = TagType.all
    if (params[:search].present?)
      @recipes = Recipe.search(params[:search]).records.to_a
    else
      @recipes = Recipe.all.reverse
      respond_with(@recipes.reverse)
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
      redirect_to login_path
    elsif !can_destroy
      raise Exceptions::NotAuthorizedError
    end
  end

  def create
    if is_signed_in
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
        MassFeedWorker.perform_async(current_member.id, str)
        respond_with(@recipe)
      else
        render json: {status: "fail" }
      end
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
end
