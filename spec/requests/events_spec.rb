require 'rails_helper'

RSpec.describe "Events", type: :request do
  
  let(:user) { create(:user, :for_organizer) } 
  let(:organizer) { user.userable }
  let(:venue) { create(:venue) }
  let(:event) { create(:event, organizer: organizer, venue: venue) }


  before {sign_in(user)}

  describe "GET /index" do
    it "returns all events ordered by datetime" do
      future_event = create(:event, datetime: 10.days.from_now)
      soon_event = create(:event, datetime: 2.days.from_now)
      
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response.body.index(soon_event.name)).to be < response.body.index(future_event.name)
    end

    it "filters events based on search query" do
      rock_event = create(:event, name: "Rock Concert")
      jazz_event = create(:event, name: "Jazz Night")
      
      get events_path, params: { query: "Rock" }
      expect(response.body).to include("Rock Concert")
      expect(response.body).not_to include("Jazz Night")
    end
  end

  describe "GET /new" do
    it "assigns new event and venue, and build ticket tiers" do
      get new_event_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /edit" do
    it "sets venue and ticket tier for updation" do
      get edit_event_path(event)
      expect(response).to have_http_status(:ok)
    end
  end
  

  describe "POST /create" do

  let(:organizer) { create(:organizer, :with_user) }
  let(:venue)     { create(:venue) }
  
  before { sign_in(organizer.user) }

  context "with an existing venue" do
    let(:valid_params) do
      {
        
        event: attributes_for(:event).merge(
          venue_id: venue.id,
          
          ticket_tiers_attributes: [attributes_for(:ticket_tier)]
        )
      }
    end

    it "creates the event successfully" do
      expect {
        post events_path, params: valid_params
      }.to change(Event, :count).by(1)
      expect(response).to redirect_to(event_path(Event.last))
    end
  end

  context "with a NEW venue" do
    let(:params_with_new_venue) do
      {
        event: attributes_for(:event, venue_id: ""), 
        venue: attributes_for(:venue, name: "Ocean View")
      }
    end

    it "creates both a new venue and a new event" do
      expect {
        post events_path, params: params_with_new_venue
      }.to change(Venue, :count).by(1).and change(Event, :count).by(1)
      
      expect(Event.last.venue.name).to eq("Ocean View")
    end
  end

  context "as a non-organizer" do
    
    let(:participant_user) { create(:user, :for_participant) } 

    before do
      sign_out(organizer.user)
      sign_in(participant_user)
    end

    it "redirects to root path with an alert" do
      post events_path, params: { event: attributes_for(:event) }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Only organizers can schedule an event")
    end
  end
end



  describe "PATCH /update" do
    let!(:event) { create(:event,organizer: organizer)}
    it "updates event attributes " do
    patch event_path(event), params: { event: { name: "My Name" } }
    expect(event.reload.name).to eq("My Name")
    end

    context "updating with a NEW venue" do
    it "creates a new venue and assigns it to the existing event" do
      expect {
        patch event_path(event), params: { 
          event: { venue_id: "" }, 
          venue: { name: "Different Place", address: "123 St", city: "NY", capacity: 100 } 
        }
      }.to change(Venue, :count).by(1)
      event.reload
      expect(event.venue.name).to eq("Different Place")
     end
    end
  end
  


  describe "DELETE /destroy" do
    it "removes the event and redirects" do
      event_to_delete = create(:event, organizer: organizer)
      expect {
        delete event_path(event_to_delete)
      }.to change(Event, :count).by(-1)
      expect(response).to redirect_to(events_path)
    end
  end

end