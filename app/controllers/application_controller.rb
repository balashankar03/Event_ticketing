class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :participant_logged_in?

  def participant_logged_in?
    user_signed_in? && current_user.userable_type.downcase=="participant"
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :userable_type, userable_attributes: [:city, :date_of_birth, :gender, :website, :address]])
  end

end
