class OrdersController < ApplicationController
  
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

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
