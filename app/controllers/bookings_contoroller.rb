class BookingsController <ApplicationController

    def create
        @event=Event.find(params[:event_id])
        current_user=session[:user_id]
        @ticket_tier=TicketTier.find(params[:ticket_tier_id])
        @quantity=params[:quantity].to_i
        amount=@quantity*@ticket_tier.price

        ActiveRecords::Base.transaction do
        if @ticket_tier.available<=@quantity
            redirect_to event_path(@event), alert: "Not enough tickets available"
        else
            @order=Order.create(participant_id: current_user,event_id: @event,amount: price,  )
            
        end
    end
end