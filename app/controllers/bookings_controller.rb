class BookingsController <ApplicationController

    def create
        @event=Event.find(params[:event_id])
        user = User.find(session[:user_id])
        @participant = user.userable
        @ticket_tier=TicketTier.find(params[:ticket_tier_id])
        quantity=params[:quantity].to_i
        amount=quantity*@ticket_tier.price
        @order=nil

        begin
        ActiveRecord::Base.transaction do
        
        @ticket_tier.lock!
        
        if @ticket_tier.remaining<quantity
            raise "Only #{@ticket_tier.remaining} tickets left."
        else
            @order=Order.create!(participant: @participant,event: @event,amount: amount,  )
            sold_count = @ticket_tier.tickets.count
            quantity.times do |i|
                @ticket=Ticket.create!(order: @order, ticket_tier: @ticket_tier, seat_info: "#{sold_count+i+1}")
            end
        end
        
        @ticket_tier.update!(remaining: @ticket_tier.remaining- quantity)
        end

        redirect_to order_path(@order)

        rescue => e
        puts "!!! BOOKING ERROR: #{e.message}"
        redirect_to events_path, alert: "Booking failed: #{e.message}"
        end

    end
end