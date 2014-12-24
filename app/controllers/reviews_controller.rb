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
        #edit num_reviews and cached_rating
        @recipe_author = @recipe.author
        if @recipe_author
          xml_builder = ::Builder::XmlMarkup.new
          single_str = xml_builder.p { |xml|
            xml.a(current_member.user_name, 'href' => member_path(current_member))
            xml.em(" just reviewed your recipe with a #{@review.rating}! ")
            xml.a(@recipe.name, 'href' => recipe_path(@recipe))
          }
          SingleFeedWorker.perform_async(@recipe.author.id, single_str)
        end
        xml_builder = ::Builder::XmlMarkup.new
        mass_str = xml_builder.p { |xml|
          xml.a(current_member.user_name, 'href' => member_path(current_member))
          xml.em(" just gave a #{@review.rating} to the recipe: ")
          xml.a(@recipe.name, 'href' => recipe_path(@recipe))
        }
        if @recipe_author
          ExceptFeedWorker.perform_async(current_member.id, mass_str, @recipe_author.id)
        else
          MassFeedWorker.perform_async(current_member.id, mass_str)
        end
        n = @recipe.num_reviews
        new_cached_rating = (n * @recipe.cached_rating + @review.rating)/(n+1)
        @recipe.update_attributes(:num_reviews => n+1, :cached_rating => new_cached_rating)
        format.json { render :json => { :status => "ok", :message => 'ok' } }
        format.js
      else
        format.json { render :json => { :status => "fail", :message => 'fail' } }
      end
    end
  end
  #PATCH/PUT  /convos/1
  def update
    @recipe = @review.reviewed_recipe
    respond_to do |format|
      if @review.update(review_params)
        #update @recipe's cached_rating
        curr_cached_rating = @recipe.cached_rating
        n = @recipe.num_reviews
        if (n > 0)
          new_cached_rating = ((n-1)*curr_cached_rating + @review.rating)/n
        else 
          new_cached_rating = @review.rating 
        end
        @recipe.update_attributes(:cached_rating => new_cached_rating)
 
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
    cached_rating = @recipe.cached_rating
    n_old = @recipe.num_reviews - 1 
    if (n_old > 0)
      new_cached_rating = (@recipe.cached_rating * (n_old + 1) - @review.rating)/n_old
    else
      new_cached_rating = 0.00
    end

    @review.destroy
    @recipe.update_attributes(:num_reviews => @recipe.num_reviews - 1,
       :cached_rating => new_cached_rating
     )
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
      redirect_to login_path
    end
  end
  def can_edit
    if !(current_member.try(:admin) || current_member == @review.reviewer)
      redirect_to root_url
    end
  end
  
end
