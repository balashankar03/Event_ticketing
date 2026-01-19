class TicketTiersController < ApplicationController
  def index
    @event=Event.find(params[:event_id])
    @ticket_tiers=TicketTier.where(event_id: params[:event_id])
    
  end

  def show
  end

  def new
    @ticket_tier=TicketTier.new
    
  end

  def create
    @event=Event.find(params[:event_id])
  end
end
