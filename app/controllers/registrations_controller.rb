class RegistrationsController < Devise::RegistrationsController
  @@debug = true
  @@default_names = ["chilibean", "sweetpea", "greenbean", "baconator", "happybaker", "cookie"]

  def new
    super
  end

  def create
    build_resource(registration_params)
    i = rand(30000000)
    n = @@default_names[rand(@@default_names.length)]
    Rails.logger.debug("RegistrationsController: #{n}")
    anoth = Member.find_by_user_name(n)
    while(anoth != nil)
      i = rand(30000000)
      anoth = Member.find_by_user_name(n+i.to_s)
      Rails.logger.debug("RegistrationsController: #{n+i.to_s}")
    end
    resource.update_attributes("user_name" => n+i.to_s, "slug" => "#{n+i.to_s}".downcase.gsub(" ","-"))
    #worked = resource.assign_attributes(:user_name => "name")
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      resource.news_feed = NewsFeed.create!(:member_id => resource.id)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        redirect_to edit_member_path(resource) #respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
#      clean_up_passwords resource
      set_minimum_password_length
      respond_with register_path
    end
  end

  
  protected

  def after_sign_up_path_for(resource)
    edit_member_path(resource)
  end

#  def after_inactive_sign_up_path_for(resource)
#    edit_member_path(resource)
#  end

  private

  def generate_random_name
    i = rand(30000000)
    name_base = @@default_names[rand(@@default_names.length)]
    anoth = Member.find_by_user_name(name_base + i.to_s)
    tries = 20
    #check if existing user has that user_name
    while(anoth != nil && tries >= 0)
     i = rand(30000000)
     tries = tries - 1
     anoth = User.find_by_user_name(name_base+i.to_s)
    end
    if (anoth == nil)
      return name_base+i.to_s
    else 
      return tria
      return nil
    end
  end

  def registration_params
    params.require(:member).permit(:email, :first, :last, :password, :password_confirmation, :user_name)
  end

end
