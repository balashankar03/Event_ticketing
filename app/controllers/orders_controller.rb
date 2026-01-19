class OrdersController < ApplicationController

  before_action :require_participant, only: [:index]
  
  def index
    @participant = Participant.find_by(id: params[:participant_id])
    
    if @participant
      @orders = @participant.orders
    else
      @orders = [] 
      flash.now[:alert] = "Participant not found."
    end
  end
  

  def show
    @order=Order.find(params[:id])
    @tickets=@order.tickets
  end



    def require_participant
    if current_user.nil? || !current_user.userable_type.eql?("Participant") || current_user.userable.id.to_s != params[:participant_id]
      redirect_to root_path, alert: "Unauthorized"
      return
    end
  end


end
