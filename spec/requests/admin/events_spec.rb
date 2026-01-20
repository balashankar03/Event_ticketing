require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:venue) { create(:venue) }
  let(:organizer) { create(:organizer) }
  let!(:event) { create(:event, name: "Summer Bash", datetime: 1.day.from_now, venue: venue, organizer: organizer) }

  before do
    # Assuming you are using Devise for ActiveAdmin authentication
    sign_in admin_user
  end

  describe "GET /admin/events" do
    it "renders the index page and displays the event" do
      get admin_events_path
      expect(response).to have_http_status(:success)
    end

    it "filters by scope :this_week" do
        
      build(:event, datetime: 1.month.ago)
      
      get admin_events_path(scope: 'this_week')
      expect(response.body).to include("Summer Bash")
    end
  end

  describe "POST /admin/events" do
    let(:valid_params) do
      {
        event: {
          name: "New Festival",
          description: "A great time",
          datetime: Time.current + 1.day,
          venue_id: venue.id,
          organizer_id: organizer.id,
          
          ticket_tiers_attributes: [
            { name: "Early Bird", price: 50, remaining: 100 }
          ]
        }
      }
    end

    it "creates a new event with ticket tiers" do
      expect {
        post admin_events_path, params: valid_params
      }.to change(Event, :count).by(1).and change(TicketTier, :count).by(1)
      
      follow_redirect!
      expect(response.body).to include("New Festival")
    end
  end

  describe "DELETE /admin/events/:id" do
    it "deletes the event" do
      expect {
        delete admin_event_path(event)
      }.to change(Event, :count).by(-1)
      expect(response).to redirect_to(admin_events_path)
    end
  end
end