class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :signed_in, only: [:show, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]

  def show
  end
  def edit
  end
  def create
    @review = Review.new(review_params)
    @recipe = @review.reviewed_recipe
    respond_to do |format|
      if @review.save
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        format.js
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
      end
    end
  end
  #PATCH/PUT  /convos/1
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review.reviewed_recipe }
        format.json { render :json => { :status => "ok", :message => 'ok' } }
      else
        format.html { redirect_to @review }
        format.json { render :json => { :status => "fail", :message => 'fail' } }
      end
    end
  end

  def destroy
    @recipe = @review.reviewed_recipe
    @review_id = @review.id
    @review.destroy
    respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end
  private
    def set_review
      @review = Review.find(params[:id])
      redirect_to not_found_path unless @review
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :rating_text, :suggestions, :reviewed_recipe_id, :reviewer_id, :pending)
    end


  def signed_in
    if !member_signed_in?
      redirect_to new_member_session_path
    end
  end
  def can_edit
    if !(current_member.try(:admin) || current_member == @review.reviewer)
      redirect_to root_url
    end
  end
  
end
