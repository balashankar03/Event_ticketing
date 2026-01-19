require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  
  let(:token) { double(resource_owner_id: user.id, accessible?: true, acceptable?: true) }
  let(:user) { create(:user, :for_participant) } 

  before do
    
    allow(controller).to receive(:doorkeeper_token).and_return(token)
    
    allow(controller).to receive(:doorkeeper_authorize!).and_return(true)
  end

  describe "GET #me" do
    it "returns the current user with their profile" do
      get :me, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(user.id)
      expect(json_response).to have_key('userable')
    end
  end

  describe "POST #create" do
    let(:valid_participant_params) do
      {
        user: {
          email: "newapi@example.com",
          password: "password123",
          password_confirmation: "password123",
          name: "API User",
          userable_type: "Participant",
          userable_attributes: {
            city: "New York",
            gender: "Non-binary"
          }
        }
      }
    end

    context "with valid parameters" do
      it "creates a new User and a Participant" do
        expect {
          post :create, params: valid_participant_params, format: :json
        }.to change(User, :count).by(1).and change(Participant, :count).by(1)
        
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid profile parameters" do
      it "does not create a user if the profile is invalid" do
        
        invalid_params = valid_participant_params
        invalid_params[:user][:userable_attributes][:city] = nil 
        
        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    it "updates the user and the nested profile" do
      patch :update, params: { 
        user: { 
          name: "Updated Name", 
          userable_attributes: { city: "London" } 
        } 
      }, format: :json
      
      user.reload
      expect(user.name).to eq("Updated Name")
      expect(user.userable.city).to eq("London")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user" do
      expect {
        delete :destroy, format: :json
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end