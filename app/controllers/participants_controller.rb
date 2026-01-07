class ParticipantsController < ApplicationController
  def index
    @participants=Participant.all
  end

  def show
    
  end

  def new
    @participant=Participant.new
    @user=User.new

  end

  def create

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def participant_params
    params.require(:participant).permit(:date_of_birth, :city, :gender)
  end
  def user_params
    params.require(:user).permit(:name,:email,:phone)
  end

end

