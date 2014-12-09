class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:show, :edit, :update, :index]
  respond_to :html

  def index
    @suggestions = Suggestion.all
    respond_with(@suggestions)
  end

  def show
    respond_with(@suggestion)
  end

  def new
    @suggestion = Suggestion.new
    respond_with(@suggestion)
  end

  def edit
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.save
    redirect_to suggestion_added_path
    #respond_with(@suggestion)
  end

  def update
    @suggestion.update(suggestion_params)
    respond_with(@suggestion)
  end

  def destroy
    @suggestion.destroy
    respond_with(@suggestion)
  end

  private
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end

    def suggestion_params
      params.require(:suggestion).permit(:who_id, :description)
    end
    def admin_only
      if !(member_signed_in? && current_member.try(:admin) == true)
       redirect_to root_url
      end
    end
end
