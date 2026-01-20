class ParticipantsController < ApplicationController

  before_action :set_participant, only: [:show]
  before_action :require_correct_participant, only: [:show]

  def index
    @participants = Participant.all
  end

  def show
    
  end

  def new
    @participant = Participant.new
    @user = User.new
  end

  private

  def set_participant
    @participant = Participant.find_by(id: params[:id])
    if @participant.nil?
      redirect_to root_path, alert: "participant not found"
    end
  end

  def require_correct_participant
    unless current_user&.userable == @participant
      redirect_to root_path, alert: "Unauthorized access."
    end
  end

  def participant_params
    params.require(:participant).permit(:date_of_birth, :city, :gender)
  end
end