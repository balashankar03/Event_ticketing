module Api
    class OrganizersController <Api::BaseController

        def index
            @organizers=Organizer.includes(:user).all
            if @organizers.empty?
                render json: [], status: :not_found
                return
            end
            render json: @organizers.as_json(include: :user)
        end

        def show
            @organizer=Organizer.find_by(id: params[:id])
            if @organizer.nil?
                render json: nil, status: :not_found
                return
            end
            render json: @organizer.as_json(include: :user)
        end


    end

end
