module Api
    class UsersController < Api::BaseController
        before_action :set_user, only: [:me, :update, :destroy]

        def me
            render json: @user.as_json(include: :userable)
        end

        def create
            @user = User.new(user_params.except(:userable_attributes))
            type = params[:user][:userable_type]
            profile_params = user_params[:userable_attributes] || {}
            @profile = (type == "Organizer" ? Organizer.new(profile_params) : Participant.new(profile_params))

            if @profile.save
                @user.userable = @profile
                if @user.save
                    render json: @user.as_json(include: :userable), status: :created
                else
                    @profile.destroy
                    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
                end
            else
                render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
            end
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
          type = @user&.userable_type || params[:user][:userable_type]
  
          permitted_base = [:email, :password, :password_confirmation, :name, :phone, :userable_type]
  
          case type
            when 'Organizer'
              permitted_base << { userable_attributes: [:id, :website, :address] }
            when 'Participant'
              permitted_base << { userable_attributes: [:id, :date_of_birth, :city, :gender] }
          end

          params.require(:user).permit(permitted_base)
        end


    end
end


