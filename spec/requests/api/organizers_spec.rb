require 'rails_helper'

RSpec.describe "Api::Organizers", type: :request do

    let(:token) { double(resource_owner_id: user.id, accessible?: true) }
    before do
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_authorize!).and_return(true)
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(token)
  end

  let!(:organizer) { create(:organizer) }
  let!(:user) { create(:user, userable: organizer) }

  describe "GET /api/organizers" do
    it "returns a list of organizers with their users" do
      get api_organizers_path 
      
      expect(response).to have_http_status(:ok)
      
    end
  end

  describe "GET /api/organizers/:id" do
    context "when the record exists" do
      it "returns the specific organizer and its user", :aggregate_failure do
        get api_organizer_path(organizer)
        
        expect(response).to have_http_status(:ok)
        
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(organizer.id)
    
      end
    end

    context "when the record does not exist" do
      it "returns a null or 404 response" do
        get "/api/organizers/0"
        expect(response).to have_http_status(:not_found)
    
      end
    end
  end
end