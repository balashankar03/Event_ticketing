require 'rails_helper'

RSpec.describe "Api::Venues", type: :request do
  let!(:venue) { create(:venue, name: "Grand Hall", city: "New York") }
  let(:headers) { { "Accept" => "application/json" } }
  let(:user) { create(:user) }
  let(:token) { double(resource_owner_id: user.id, accessible?: true, acceptable?: true) }

  before do  
  allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_authorize!).and_return(true)
  allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(token)
  end

  describe "GET /api/venues" do
    it "returns all venues" do
      get "/api/venues", headers: headers
      
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["name"]).to eq("Grand Hall")
    end
  end

  describe "GET /api/venues/:id" do
    it "returns the specific venue" do
      get "/api/venues/#{venue.id}", headers: headers
      
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["city"]).to eq("New York")
    end
  end

  describe "POST /api/venues" do
    context "with valid parameters" do
      let(:valid_params) do
        { venue: { name: "Music Bowl", address: "456 St", capacity: 500, city: "Boston" } }
      end

      it "creates a new venue" do
        expect {
          post "/api/venues", params: valid_params, headers: headers
        }.to change(Venue, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable entity" do
        post "/api/venues", params: { venue: { name: "" } }, headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /api/venues/:venue_id/eventlist" do
    context "when venue exists" do
      it "renders the events index template/json" do
        create(:event, venue: venue, name: "Concert A")
        
        
        get "/api/venues/#{venue.id}/events", as: :json
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Concert A")
      end
    end

    context "when venue does not exist" do
      it "returns 404 not found" do
        get "/api/venues/9999/events", headers: headers
        
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Venue not found")
      end
    end
  end
end