class OrganizersController < ApplicationController
  before_action:require_organizer

  def index
  end

  def show
    @organizer=Organizer.find_by(id: params[:id])
    if @organizer.nil?
      redirect_to root_path, alert: "Organizer not found"
      return
    end
    @events=@organizer.events
  end

  def require_organizer
  unless current_user&.userable_type == "Organizer" && current_user.userable_id.to_s == params[:id].to_s
    redirect_to root_path, alert: "Unauthorized access. Please log in as the correct Organizer."
  end
 end


  private
  def organizer_params
    params.require(:organizer).permit(:website,:address)
  end
  def user_params
    params.require(:user).permit(:name,:email,:phone)
  end



end
