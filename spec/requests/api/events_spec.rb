require 'rails_helper'

RSpec.describe "Api::Events", type: :request do
  let!(:user) { create(:user, :for_organizer) }
  let!(:organizer) { user.userable }
  let!(:venue) { create(:venue) }
  let!(:category) { create(:category) }
  
  
  let(:token) { double(resource_owner_id: user.id, accessible?: true) }

  before do
    
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_authorize!).and_return(true)
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(token)

    
    allow_any_instance_of(Api::EventsController).to receive(:api_authorize_organizer!).and_wrap_original do |method, *args|
      method.receiver.instance_variable_set(:@current_organizer, organizer)
      true
    end
  end

  describe "GET /api/events" do
    it "returns a list of all events" do
      create_list(:event, 3)

      get "/api/events", as: :json 
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/events" do
    let(:valid_attributes) do
      {
        event: {
          name: "Grand Music Gala",
          description: "An orchestral performance.",
          venue_id: venue.id,
          datetime: Time.now + 1.week,
          category_ids: [category.id],
          ticket_tiers_attributes: [
            { name: "Gold", price: 150.0, remaining: 50 },
            { name: "Silver", price: 80.0, remaining: 100 }
          ]
        }
      }
    end

    context "with valid parameters" do
      it "creates a new Event and nested TicketTiers" do
        expect {
          post "/api/events", params: valid_attributes, as: :json
        }.to change(Event, :count).by(1).and change(TicketTier, :count).by(2)

        expect(response).to have_http_status(:created)
        expect(Event.last.organizer).to eq(organizer)
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable content" do
        valid_attributes[:event][:name] = "" 
        post "/api/events", params: valid_attributes, as: :json
        
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "GET /api/events/:id/stats" do
    let!(:event) { create(:event, organizer: organizer) }
    let!(:tier) { create(:ticket_tier, event: event, price: 100, remaining: 50) }
    
    it "returns the correct revenue and capacity data" do
      participant_user = create(:user, :for_participant)
      order = create(:order, event: event, participant: participant_user.userable, status: "confirmed")
      create(:ticket, order: order, ticket_tier: tier)

      get "/api/events/#{event.id}/stats", as: :json

      json = JSON.parse(response.body)
      expect(json["tickets_sold"]).to eq(1)
      expect(json["revenue"]).to eq(100.0)
      expect(json["total_capacity"]).to eq(51) 
    end
  end

  describe "POST /api/events/:id/validate_ticket" do
    let!(:event) { create(:event) }
    let!(:tier) { create(:ticket_tier, event: event) }
    let!(:participant_user) { create(:user, :for_participant, name: "Alice Smith") }
    let!(:order) { create(:order, event: event, participant: participant_user.userable, status: "confirmed") }
    let!(:ticket) { create(:ticket, order: order, ticket_tier: tier, serial_no: "VALID123") }

    it "validates a correct ticket and returns participant name" do
      post "/api/events/#{event.id}/validate_ticket", params: { serial_no: "VALID123" }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["valid"]).to be true
      expect(json["participant"]).to eq("Alice Smith")
    end
  end

    describe "GET /api/events/upcoming" do
    it "only returns events in the future" do
        past_event = build(:event, datetime: Time.now - 1.day)
        past_event.save(validate: false)
        create(:event, datetime: Time.now + 2.days)

        get "/api/events/upcoming", as: :json
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        events = json.is_a?(Array) ? json : json["events"]
        
        expect(events.none? { |e| e["id"] == past_event.id }).to be true
    end
    end

  describe "GET /api/events/:id/availability" do
    let!(:event) { create(:event) }
    let!(:tier) { create(:ticket_tier, event: event, remaining: 5) }

    it "returns the ticket availability for the event" do
        get "/api/events/#{event.id}/availability", as: :json
    
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["tiers"].first["remaining"]).to eq(5)
    end
  end
end