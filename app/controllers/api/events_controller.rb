module Api
    class EventsController <Api::BaseController
        before_action :api_authorize_organizer!, only: [:create, :update, :destroy]
        before_action :set_event, only: [:show, :update, :destroy, :attendees, :stats, :validate_ticket, :availability]
        
        def index
            @events=Event.all
        end

        def show
            @event
        end

        def create
            organizer=@current_organizer
            @event=Event.new(event_params)
            @event.organizer=organizer
            if @event.save
                @event.reload
                render 'show', status: :created 
            else
                render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
            end
        end

        def update
            if @event.update(event_params)
                render 'show', status: :ok
            else
                render json: {errors: @event.errors.full_messages}, status: :unprocessable_entity
            end
        end

        def destroy
            if @event.destroy
                render json: {message: "Event deleted successfully"}, status: :ok
            else
                render json: {error: "Failed to delete event"}, status: :unprocessable_entity
            end
        end

        def attendees
            @participants=@event.participants
            render 'participants', status: :ok

        end

        def upcoming
            @events=Event.where('datetime > ?',Time.now).order(datetime: :asc)
            render 'index', status: :ok
        end

        def stats
            stats = {
                total_capacity: @event.ticket_tiers.sum(:remaining) + @event.tickets.count,
                tickets_sold: @event.tickets.count,
                revenue: @event.tickets.joins(:ticket_tier).sum("ticket_tiers.price").to_f,
                tiers: @event.ticket_tiers.map { |t| { name: t.name, sold: t.tickets.count, remaining: t.remaining } }
            }
            render json: stats
        end

        def validate_ticket
            ticket = @event.tickets.find_by(serial_no: params[:serial_no])
            
            if ticket && ticket.order.status != "cancelled"
                render json: { valid: true, participant: ticket.order.participant.user.name, tier: ticket.ticket_tier.name }
            else
                render json: { valid: false, error: "Invalid or cancelled ticket" }, status: :not_found
            end
        end

        def availability
            availability_data = @event.ticket_tiers.map do |tier|
                {
                tier_id: tier.id,
                name: tier.name,
                price: tier.price.to_f,
                remaining: tier.remaining,
                status: tier.remaining > 0 ? "available" : "sold_out"
                }
            end

            render json: {
                event_id: @event.id,
                event_name: @event.name,
                total_remaining: @event.ticket_tiers.sum(:remaining),
                tiers: availability_data
            }, status: :ok
            end

        private

        def event_params
            params.require(:event).permit(:name,:description, :venue_id, :datetime, ticket_tiers_attributes: [:id, :name, :price, :remaining, :_destroy], category_ids: [])
        end

        def set_event
            @event=Event.find_by(id: params[:id])
            if @event.nil?
                render json: {error: "Event not found"}, status: :not_found and return
            end
        end



    end
end
        
