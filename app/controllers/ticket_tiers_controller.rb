class TicketTiersController < ApplicationController
  def index
    @ticket_tiers=TicketTier.where(event_id: params[:event_id])
    
  end

  def show
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
