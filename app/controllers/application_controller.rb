class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :participant_logged_in?

  def participant_logged_in?
    session[:user_id] && session[:role].downcase=="participant"
  end

end
