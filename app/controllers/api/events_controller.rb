module Api
    class EventsController <Api::BaseController
        
        def index
            @event=Event.all
            render json: @event
        end

        def show
            @event=Event.find_by(id: params[:id])
            render json: @event
        end

        def create
            user=User.where(userable_type: "Organizer").first
            organizer=user.userable
            @event=Event.new(event_params)
            @event.organizer=organizer
            if @event.save
                render json: @event, status: :created
            else
                render json: {errors: @event.errors.full_messages}, status: :unprocessable_entity
            end
        end

        def update
            @event=Event.find_by(id: params[:id])
            if @event.nil?
                render json: {error: "Event not found"}, status: :not_found and return
            end

            if @event.update(event_params)
                render json: @event.as_json(include: :ticket_tiers), status: :ok
            else
                render json: {errors: @event.errors.full_messages}, status: :unprocessable_entity
            end
        end

        private

        def event_params
            params.require(:event).permit(:name,:description, :venue_id, :datetime, ticket_tiers_attributes: [:id, :name, :price, :remaining, :_destroy], category_ids: [])
        end

    end
end
        
