class Users::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    if params[:type] == "Organizer"
      resource.userable = Organizer.new
    else
      resource.userable = Participant.new
    end
    respond_with self.resource
  end

  def create
    build_resource(sign_up_params.except(:userable_attributes))

    type = params[:user][:userable_type]
    profile_attributes = sign_up_params[:userable_attributes]
    
    profile = (type == "Organizer" ? Organizer.new(profile_attributes) : Participant.new(profile_attributes))

    if profile.save
      resource.userable = profile

      if resource.save
        yield resource if block_given?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          
          session[:user_id] = resource.id
          session[:role] = resource.userable_type.downcase
          
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        profile.destroy
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource, status: :unprocessable_entity
      end

    else
      profile.errors.each { |error| resource.errors.add(error.attribute, error.message) }
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, status: :unprocessable_entity

    end 
  end
   
end