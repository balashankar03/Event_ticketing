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
    @participant=Participant.new(participant_params)
    @user=User.new(user_params)
    @event=Event.find_by(id: params[:event_id])

    @user.userable=@participant

    if @participant.save && @user.save
      session[:user_id]=@user.id
      session[:role]="Participant"

      if @event
        redirect_to event_path(@event), notice: "Participant account created successfully! You can now book tickets for the event."
      else
        redirect_to events_path, notice: "Participant account created successfully! You can now browse and book tickets for events."
      end
    
    else
      render :new, status: :unprocessable_entity
    end


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

