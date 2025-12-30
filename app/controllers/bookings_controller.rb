class BookingsController <ApplicationController
    before_action :set_event, only: [:create]
    before_action :require_participant, only: [:create]
    before_action :set_ticket_tier, only: [:create]


    def create
        quantity=params[:quantity].to_i
        @amount=quantity*@ticket_tier.price
        @order=nil

        begin
        ActiveRecord::Base.transaction do
        
        @ticket_tier.lock!
        
        if @ticket_tier.remaining<quantity
            raise "Only #{@ticket_tier.remaining} tickets left."
        else
            @order=Order.create!(participant: @participant,event: @event)
            sold_count = @ticket_tier.tickets.count
            quantity.times do |i|
                @ticket=Ticket.create!(order: @order, ticket_tier: @ticket_tier, seat_info: "#{sold_count+i+1}")
            end
        end
        
        @ticket_tier.update!(remaining: @ticket_tier.remaining- quantity)
        end

        redirect_to order_path(@order, amount: @amount)

        rescue => e
        puts "!!! BOOKING ERROR: #{e.message}"
        redirect_to events_path, alert: "Booking failed: #{e.message}"
        end

    end

    private
    def set_event
        @event=Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to events_path, alert: "Event not found"
            return
            
    end

    def set_ticket_tier
        @ticket_tier=TicketTier.find(params[:ticket_tier_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to event_path(@event), alert: "Ticket tier not found"
            return
            
    end
    def require_participant
        if current_user.nil?
            redirect_to new_user_session_path, alert: "You must be logged in to book tickets."
            return
        end

        if current_user.userable_type.downcase != "participant"
            redirect_to root_path, alert: "Only participants can book tickets."
            return
        else
            @participant=current_user.userable
        end
    end


end