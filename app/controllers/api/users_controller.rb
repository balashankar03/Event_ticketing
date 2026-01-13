module Api
    class UsersController < Api::BaseController
        before_action :set_user
        def me
            render json: @user.as_json(include: :userable)
        end

        def update
            user_updated = @user.update(user_params.except(:userable_attributes))
            profile_params = user_params[:userable_attributes]
            profile_updated = profile_params ? @user.userable.update(profile_params) : true
            if user_updated && profile_updated
                render json: @user.as_json(include: :userable)
            else
                render json: { errors: @user.errors.full_messages + @user.userable.errors.full_messages }, 
                status: :unprocessable_entity
            end
        end

        def destroy
            if @user.destroy
                render json: {message: "User profile destroyed successfully"}, status: :ok
            else
                render json: {error: "Failed to delete User"}, status: :unprocessable_entity
            end
        end



        private

        def set_user
            @user = User.includes(:userable).find_by(id: doorkeeper_token.resource_owner_id)
            if @user.nil?
                render json: {error: "User not found"}, status: :not_found and return
            end
        end

        def user_params
            permitted_params = [:name, :email, :phone]
            case @user.userable_type
                when 'Organizer'
                    permitted_params << { userable_attributes: [:id, :website, :address] }
                when 'Participant'
                    permitted_params << { userable_attributes: [:id, :date_of_birth, :city, :gender] }
            end

            params.require(:user).permit(permitted_params)
        end


    end
end


