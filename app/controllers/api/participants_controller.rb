module Api
    class ParticipantsController <Api::BaseController

        def index
            @participants=Participant.includes(:user).all
            render json: @participants.as_json(include: :user)
        end

        def show
            @participant=Participant.find_by(id: params[:id])
            render json: @participant.as_json(include: :user)
        end

        


    end

end