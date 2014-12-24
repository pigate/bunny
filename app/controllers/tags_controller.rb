class TagsController < ApplicationController
  def index
  end
  #POST /tags
  #POST /tags.json
  def create
    if member_signed_in? && member.admin == true
      @tag = Tag.new(tag_params)
      if @tag.save

      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    else
      format.html { render :new }    
      format.json { render json: @rating.errors, status: :unprocessable_entity }
    end
  end
  #PATCH/PUT  /tags/1
  def update
    if current_member.try(:admin?)
      if @tag.update(tag_prams)
       
        render json: { status: :ok }
      end
    else
       render json: { status: :unprocessable_entity }
    end
  end

  def destroy
    if current_member.try(:admin?)
       @tag.destroy
       format.js
    end
  end
end
