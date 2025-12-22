class OrdersController < ApplicationController
  def index
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
