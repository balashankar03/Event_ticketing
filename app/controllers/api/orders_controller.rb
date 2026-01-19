module Api
    class OrdersController <Api::BaseController
        before_action :api_authorize_participant!
        before_action :set_event, only: [:create]
        before_action :set_ticket_tier, only: [:create]

        def index
            @orders=Order.includes(:tickets).all
            render json: @orders.as_json(include: :tickets)
        end

        def show
            @order=Order.find_by(id: params[:id])
            render json: @order.as_json(include: :tickets)
        end

        def mytickets
            @participant=current_resource_owner.userable
            @orders=@participant.orders
            render 'show', status: :ok

        end

        def create
            quantity = params[:quantity].to_i
            
            begin
                ActiveRecord::Base.transaction do
                @ticket_tier.lock! # Pessimistic locking for concurrency

                if @ticket_tier.remaining < quantity
                    render json: { error: "Only #{@ticket_tier.remaining} tickets left." }, status: :unprocessable_entity
                    raise ActiveRecord::Rollback
                    return # Prevents further execution after rollback
                end

                @order = Order.create!(
                    participant: @current_participant, 
                    event: @event,
                    status: "confirmed"
                )

                sold_count = @ticket_tier.tickets.count
                quantity.times do |i|
                    Ticket.create!(
                    order: @order, 
                    ticket_tier: @ticket_tier, 
                    seat_info: "Seat-#{sold_count + i + 1}",
                    )
                end

                @ticket_tier.update!(remaining: @ticket_tier.remaining - quantity)

                # SUCCESS: Render inside the transaction block
                render json: {
                    message: "Order created successfully",
                    order_id: @order.id,
                    total_amount: (quantity * @ticket_tier.price).to_f,
                    tickets: @order.tickets
                }, status: :created
                return # Exit method entirely
                end
            rescue => e
                # Double check that we haven't already rendered an error
                unless performed?
                render json: { error: "Booking failed: #{e.message}" }, status: :internal_server_error
                end
            end
        end


  
        def cancel
            @order = Order.find(params[:id])

            return render json: { error: "Unauthorized" }, status: :unauthorized unless @order.participant_id == @current_participant.id

            begin
            ActiveRecord::Base.transaction do
                @order.update!(status: "cancelled")

                @order.tickets.each do |ticket|
                tier = ticket.ticket_tier
                tier.increment!(:remaining)
                end
            end

            render json: { message: "Order cancelled and tickets restocked." }, status: :ok
            rescue => e
            render json: { error: "Cancellation failed" }, status: :bad_request
            end
        end

        private

        def set_event
            @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Event not found" }, status: :not_found
        end

        def set_ticket_tier
            @ticket_tier = TicketTier.find(params[:ticket_tier_id])
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Ticket tier not found" }, status: :not_found
        end
        
    end
end

