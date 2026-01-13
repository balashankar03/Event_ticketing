class ApiLoginsController < ApplicationController
    def new

    end

    def create

        response= HTTParty.post("http://localhost:3000/oauth/token", body: {
        grant_type: "password",
        username: params[:username],
        password: params[:password],
        client_id: "GXnpYW8rsJ0_LMOG3Z_1aa8GS_s6el9NbyWUKc6lvTU",
        client_secret: "B8sad_fwJ-0evHuUI1lCp9-V5qqUrsq5C0EJFMtHKJ4",
        })

        if response.success?
            session[:access_token] = response["access_token"]
            Rails.logger.debug "CURRENT ACCESS TOKEN: #{session[:access_token]}"
        else
            redirect_to api_login_path, alert: "invalid email or password"
            return
        end

        user=User.find_by(email: params[:email])

        if user&.organizer?
            redirect_to organizer_dashboards_path
        else
            redirect_to participant_dashboards_path
        end
        

    end

    def destroy
        session[:access_token] = nil
        redirect_to login_path, notice: "Logged out!"
    end

    

end