module Api
    class VenuesController <Api::BaseController

        before_action :set_venue, only: [:show, :eventlist, :update]
        
        def index
            @venues=Venue.all
            render json: @venues
        end

        def show
            render json: @venue
        end

        def create
            @venue=Venue.new(venue_params)
            if @venue.save
                render json: @venue, status: :created 
            else
                render json: { errors: @venue.errors.full_messages }, status: :unprocessable_entity
            end          

        end

        def update
            if @venue.update(venue_params)
                render json: @venue, status: :ok
            else
                render json: { errors: @venue.errors.full_messages }, status: :unprocessable_entity
            end
        end


        def eventlist
            @events=@venue.events
            if @events.nil?
                render json: {"error":"no events in this venue"}, status: :not_found
            end
            render 'api/events/index', status: :ok
        end


        private

        def venue_params
            params.require(:venue).permit(:name, :address, :capacity, :city)
        end

        def set_venue
            @venue=Venue.find_by(id: params[:id])
            if @venue.nil?
                render json: {error: "Venue not found"}, status: :not_found and return
            end

        end

    end


end