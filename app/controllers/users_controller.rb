class UsersController < ApplicationController
before_action :authorize_user, only: [:show,:edit, :update, :destroy]
before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show
    @profile=@user.userable
  end

  def new
  end

  def create
  end

  def edit
    @profile=@user.userable

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
  def set_user
    @user=User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "User not found"
      return
    end
  end

  def authorize_user
    redirect_to root_path, alert: "Unauthorized" unless params[:id]==current_user.id.to_s
    return
  end

  def user_params
    params.require(:user).permit(:name, :phone, :profile_picture, userable_attributes: [:id, :city, :date_of_birth, :website, :address])
  end
end
