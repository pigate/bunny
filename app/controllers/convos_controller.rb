class ConvosController < ApplicationController
  before_action :signed_in, only: [:show, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]

  def show
    
  end
  #POST /convos
  #POST /convos.json
  def create
    if member_signed_in? 
      @convo = Convo.new(convo_params)
      if @convo.save
        render json: { status: "ok" }
      else
        #format.html { render :new }
        #format.json { render json: @convo.errors, status: :unprocessable_entity }
        render json: {status: "fail" }
      end
    else
      #format.html { render :new }    
      render json: { status: "fail" }
      #format.json { render json: @convo.errors, status: :unprocessable_entity }
    end
  end
  #PATCH/PUT  /convos/1
  def update
    if current_member.try(:admin?)
      if @convo.update(convo_params)
       
        format.json { status: :ok }
      end
    else
       format.json { status: :unprocessable_entity }
    end
  end

  def destroy
    if current_member.try(:admin?)
       @convo.destroy
       format.js
    end
  end
  private
    def set_convo
      @convo = Convo.find(params[:id])
      redirect_to not_found_path unless @convo
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def convo_params
      params.require(:convo).permit(:write_access_level, :owner_id, :conversable_id, :conversable_type)
    end


  def signed_in
    if !member_signed_in?
      redirect_to new_member_session_path
    end
  end
  def can_edit
    if !(member_signed_in? && current_member.try(:admin))
      redirect_to root_url
    end
  end
  
end
