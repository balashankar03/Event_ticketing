module Api
    class EventsController <Api::BaseController
        before_action :api_authorize_organizer, only: [:create, :update, :destroy]
        before_action :set_event, except: [:index, :upcoming]
        
        def index
            @events=Event.all
        end

        def show
            @event
        end

        def create
            user=User.where(userable_type: "Organizer").first
            organizer=user.userable
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
        
