require 'rails_helper'

RSpec.describe "Bookings", type: :request do
  let(:participant_user) { create(:user, :for_participant) }
  let(:participant)      { participant_user.userable }
  let(:event)            { create(:event) }
  let(:ticket_tier)      { create(:ticket_tier, event: event, price: 100, remaining: 10) }

  describe "POST /create" do
    let(:valid_params) do
      {
        event_id: event.id,
        ticket_tier_id: ticket_tier.id,
        quantity: 2
      }
    end

    context "when a participant is logged in" do
      before { sign_in participant_user }

      it "creates an order and the correct number of tickets" do
        expect {
          post event_bookings_path(event), params: valid_params
        }.to change(Order, :count).by(1)
         .and change(Ticket, :count).by(2)

        
        expect(ticket_tier.reload.remaining).to eq(8)
        
        
        expect(response).to redirect_to(order_path(Order.last, amount: 200.0))
      end

      it "fails if quantity exceeds remaining tickets" do
        post event_bookings_path(event), params: valid_params.merge(quantity: 11)
        
        expect(response).to redirect_to(events_path)
        expect(flash[:alert]).to include("Only 10 tickets left")
        expect(Order.count).to eq(0) 
      end
    end

    context "when an organizer is logged in" do
      let(:organizer_user) { create(:user, :for_organizer) }
      before { sign_in organizer_user }

      it "denies access and redirects to root" do
        post event_bookings_path(event), params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Only participants can book tickets.")
      end
    end

    context "when guest is not logged in" do
      it "redirects to login page" do
        post event_bookings_path(event), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end