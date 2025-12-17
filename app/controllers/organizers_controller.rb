class OrganizersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @organizer=Organizer.new
    @user=User.new

  end

  def create
    @organizer=Organizer.new(organizer_params)
    @user=User.new(user_params)

    @user.userable=@organizer

    if @organizer.save && @user.save
      session[:user_id]=@user.id
      session[:role]="Organizer"
      redirect_to new_event_path
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
  def organizer_params
    params.require(:organizer).permit(:website,:address)
  end
  def user_params
    params.require(:user).permit(:name,:email,:phone)
  end

end
