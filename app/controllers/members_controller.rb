class MembersController < ApplicationController
  include NewsFeedHelper
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :is_signed_in, only: [:edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :can_destroy, only: [:update, :destroy]
  # GET /members
  # GET /members.json
  def index
    if (params[:search_members].present?)
      @members = Member.search(params[:search_members]).records.to_a
    else
      @members = Member.limit(8)
    end

  end

  # GET /members/1
  # GET /members/1.json
  def show

  end

  # GET /members/new

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    i = rand(30000000)
    n = "ChiliBean"
    n_s = "ChiliBean"+i.to_s
    Rails.logger.debug("RegistrationsController: #{n_s}")
    anoth = Member.find_by_user_name(n)
    while(anoth != nil)
      i = rand(30000000)
      anoth = Member.find_by_user_name(n+i.to_s)
      Rails.logger.debug("RegistrationsController: #{n+i.to_s}")
    end
    @member.update_attributes("user_name" => n+i.to_s, "slug" => "#{n+i.to_s}".downcase.gsub(" ","-"))

    respond_to do |format|
      if @member.save
        @member.news_feed = NewsFeed.new(:member_id => @member.id)
        format.html { redirect_to edit_member_path(@member), notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: edit_member_path(@member) }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      @member.update_attributes('slug' => member_params[:user_name].downcase.gsub(' ','-').gsub('\n',''))
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      id = params[:id]
      if /[A-Za-z]/.match(id)
        @member = Member.find_by_slug(id)
      else
        @member = Member.find_by_id(id)
      end
      redirect_to not_found_path unless @member
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:first, :last, :user_name, :occupation, :email, :photo, :password, :password_confirmation, :slug)
    end
    def can_edit
      current_member.admin || current_member.id == params[:id]
    end
    def is_signed_in
      redirect_to login_path unless current_member  
    end
    def can_destroy
      current_member.admin && current_member.id != params[:id] || (!current_member.admin && current_member.id == params[:id])
    end
end
