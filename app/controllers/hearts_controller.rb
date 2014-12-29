class HeartsController < ApplicationController
  include NewsFeedHelper

  before_action :set_heart, only: [:destroy]

  before_action :signed_in, only: [:create, :destroy]
  #POST /hearts
  #POST /hearts.json
  def index
    redirect_to not_found_path
    @hearts = Heart.all
  end
  def new
    @heart = Heart.new
  end
  
  def create
    @heart = Heart.new(heart_params)
    respond_to do |format|
      if @heart.save
        @recipe = Recipe.find(@heart.liked_recipe_id)
        if @recipe.author != current_member
          if @recipe.author 
            xml_builder = ::Builder::XmlMarkup.new
            single_str = xml_builder.p { |xml|
              xml.a(current_member.user_name, 'href' => member_path(current_member))
              xml.em(" just 'hearted' your recipe! ")
              xml.a(@recipe.name, 'href' => recipe_path(@recipe))
            }
            single_feed_push(@recipe.author.id, single_str)
            #SingleFeedWorker.perform_async(@recipe.author.id, single_str)
          end
          xml_builder = ::Builder::XmlMarkup.new
          mass_str = xml_builder.p { |xml|
            xml.a(current_member.user_name, 'href' => member_path(current_member))
            xml.em(" just 'hearted' the recipe: ")
            xml.a(@recipe.name+"!", 'href' => recipe_path(@recipe))
          }
          except_feed_push(current_member.id, mass_str, @recipe.author.id)
          #ExceptFeedWorker.perform_async(current_member.id, mass_str, @recipe.author.id)
        end
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        format.js
        #render :json { :success => false }
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
        #render :json { :success => false }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(@heart.liked_recipe_id)
    if @heart.destroy
      respond_to do |format|
        format.html {} 
        format.js
      end
    end
  end
  private
    def set_heart
      @heart = Heart.find(params[:id])
      redirect_to not_found_path unless @heart
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def heart_params
      params.require(:heart).permit(:liker_id, :liked_recipe_id)
    end


  def signed_in  
    if !member_signed_in?
      render :js => "window.location.replace('#{login_path}');"
    end
  end
end
