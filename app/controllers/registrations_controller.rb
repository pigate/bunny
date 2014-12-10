class RegistrationsController < Devise::RegistrationsController
  @@debug = false
  @@default_names = ["chilibean", "sweetpea", "greenbean", "baconator", "happybaker", "cookie"]

  def create
    build_resource(registration_params)
    if !@@debug
      i = rand(30000000)
      name_base = @@default_names[rand(@@default_names.length)]
      anoth = Member.find_by_user_name(name_base + i.to_s)
      tries = 10
      while(anoth != nil && tries >= 0)
       i = rand(30000000)
       tries = tries - 1
       anoth = User.find_by_chosen_name(name_base+i.to_s)
      end
      resource.update_attributes("user_name" => name_base + i.to_s, "slug" => "#{name_base + i.to_s}".downcase.gsub(' ','-'))
    elsif @@debug == true
      name_base = "Mimi"
      resource.update_attributes("user_name" => name_base, "slug" => name_base.downcase.gsub(' ','-'))
    end
    resource_saved = resource.save
    if !resource_saved
      if resource.errors[:email]
      elsif resource.errors[:user_name] != nil
        while(!resource_saved)
          name_base = name_base + rand(10).to_s
          resource.update_attributes("user_name" => name_base+i.to_s, "slug" => "#{name_base + i.to_s}".downcase.gsub(' ','-'))
          resource_saved = resource.save
        end
      end
    end
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end
  
  protected

  def after_sign_up_path_for(resource)
    edit_member_path(resource)
  end

  def after_inactive_sign_up_path_for(resource)
    edit_member_path(resource)
  end

  private

  def registration_params
    params.require(:member).permit(:email, :first, :last, :password, :password_confirmation)
  end

end
