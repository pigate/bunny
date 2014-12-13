class HeartsController < ApplicationController
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
      render :js => "window.location.replace('#{new_member_session_path}');"
    end
  end
end
