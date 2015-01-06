class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]
  before_action :can_edit, only: [:new, :edit, :update, :destroy]
  def index
    @tags = Tag.all
    respond_to do |format|
      format.json { render :json => @tags }
    end
  end
  #POST /tags
  #POST /tags.json

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
       format.html { redirect_to tag_types_path }
       format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    
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
       redirect_to tag_types_path
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :tag_type_id)
  end

  def set_tag
    id = params[:id]
    @tag = Tag.find(id)
  end

  def can_edit
    current_member.try(:admin)
  end
end
