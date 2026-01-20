require 'rails_helper'

RSpec.describe "TicketTiers", type: :request do
  
  let(:event) { create(:event) }
  
  let!(:tier_one) { create(:ticket_tier, event: event, name: "General Admission") }
  let!(:tier_two) { create(:ticket_tier, event: event, name: "VIP") }

  let!(:other_tier) { create(:ticket_tier) }

  describe "GET /events/:event_id/ticket_tiers" do
    it "returns a successful response and assigns the correct data" do
      
      get event_ticket_tiers_path(event)

      expect(response).to have_http_status(:ok)
    
    end
  end
end