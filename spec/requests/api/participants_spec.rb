require 'rails_helper'

RSpec.describe "Api::Participants", type: :request do

    let(:token) { double(resource_owner_id: user.id, accessible?: true) }
    before do
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_authorize!).and_return(true)
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(token)
    end

  let!(:participant) { create(:participant) }
  let!(:user) { create(:user, userable: participant) }

  describe "GET /api/participants" do
    it "returns a list of participants with their users" do
      get api_participants_path 
      
      expect(response).to have_http_status(:ok)
      
    end
  end

  describe "GET /api/participants/:id" do
    context "when the record exists" do
      it "returns the specific participant and its user", :aggregate_failure do
        get api_participant_path(participant)
        
        expect(response).to have_http_status(:ok)
        
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(participant.id)
    
      end
    end

    context "when the record does not exist" do
      it "returns a null or 404 response" do
        get "/api/participants/0"
        expect(response).to have_http_status(:not_found)
    
      end
    end
  end
end