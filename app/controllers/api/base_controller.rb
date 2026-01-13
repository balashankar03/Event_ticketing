module Api
    class BaseController < ActionController::API
        before_action :doorkeeper_authorize!

        private

        def current_resource_owner
            @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
        end

        def api_authorize_organizer!
            user = User.find(doorkeeper_token.resource_owner_id)
            unless user.organizer?
            render json: { error: "Forbidden", message: "Organizer role required" }, status: :forbidden and return
            end
        end

        def api_authorize_participant!
            user = User.find(doorkeeper_token.resource_owner_id)
            unless user.participant?
            render json: { error: "Forbidden", message: "Participant role required" }, status: :forbidden and return
            end
        end

    end
end

