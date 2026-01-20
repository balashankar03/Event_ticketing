module Api
    class ParticipantsController <Api::BaseController

        def index
            @participants=Participant.includes(:user).all
            render json: @participants.as_json(include: :user)
        end

        def show
            @participant=Participant.find_by(id: params[:id])
            if @participant.nil?
                render json: nil, status: :not_found
                return
            end
            render json: @participant.as_json(include: :user)
        end

        


    end

end