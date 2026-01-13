module Api
    class OrganizersController <Api::BaseController

        def index
            @organizers=Organizer.includes(:user).all
            render json: @organizers.as_json(include: :user)
        end

        def show
            @organizer=Organizer.find_by(id: params[:id])
            render json: @organizer.as_json(include: :user)
        end


    end

end
