require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  # We use the Devise mapping because this is a custom Devise controller
  before(:each) do
    @derived_mapping = Devise.mappings[:user]
  end

  describe "GET /users/sign_up" do
    it "successfully renders the sign up page for an Organizer" do
      get new_user_registration_path, params: { type: "Organizer" }
      expect(response).to have_http_status(:success)
    end

    it "successfully renders the sign up page for a Participant" do
      get new_user_registration_path, params: { type: "Participant" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    let(:valid_user_params) do
      {
        email: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end

    context "when registering as an Organizer" do
      let(:organizer_params) do
        {
          user: valid_user_params.merge(
            userable_type: "Organizer",
            userable_attributes: { website: "https://event.com", address: "123 Street" }
          )
        }
      end

      it "creates a new user and an organizer profile" do
        expect {
          post user_registration_path, params: organizer_params
        }.to change(User, :count).by(1).and change(Organizer, :count).by(1)

        expect(User.last.userable_type).to eq("Organizer")
        expect(session[:role]).to eq("organizer")
      end
    end

    context "when registering as a Participant" do
      let(:participant_params) do
        {
          user: valid_user_params.merge(
            userable_type: "Participant",
            userable_attributes: { date_of_birth: "1995-01-01" }
          )
        }
      end

      it "creates a new user and a participant profile" do
        expect {
          post user_registration_path, params: participant_params
        }.to change(User, :count).by(1).and change(Participant, :count).by(1)

        expect(User.last.userable_type).to eq("Participant")
        expect(session[:role]).to eq("participant")
      end
    end

    context "with invalid data" do
      it "does not create a user if profile validation fails" do
        # Example: Participant requires a date_of_birth (assuming validation exists)
        invalid_params = {
          user: valid_user_params.merge(
            userable_type: "Participant",
            userable_attributes: { date_of_birth: nil } 
          )
        }

        expect {
          post user_registration_path, params: invalid_params
        }.not_to change(User, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end