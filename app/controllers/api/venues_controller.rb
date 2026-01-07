module Api
    class VenuesController <Api::BaseController
        
        def index
            @venues=Venue.all
            render json: @venues
        end

        def show
            @venue=Venue.find_by(id: params[:id])
            render json: @venue
        end

    end


end