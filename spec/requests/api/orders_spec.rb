require 'rails_helper'

RSpec.describe "Api::Orders", type: :request do
  let!(:user) { create(:user, :for_participant) }
  let!(:participant) { user.userable }
  let!(:event) { create(:event) }
  let!(:ticket_tier) { create(:ticket_tier, event: event, remaining: 10, price: 100) }
  
  let(:token) { double(resource_owner_id: user.id, accessible?: true) }

  before do
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_authorize!).and_return(true)
    allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(token)

    allow_any_instance_of(Api::OrdersController).to receive(:api_authorize_participant!).and_wrap_original do |method, *args|
      method.receiver.instance_variable_set(:@current_participant, participant)
      true
    end
  end

  describe "POST /api/orders" do
    let(:valid_params) do
      {
        event_id: event.id,
        ticket_tier_id: ticket_tier.id,
        quantity: 2
      }
    end

    context "with valid availability" do
      it "creates an order and reduces ticket tier inventory" do
        expect {
        
          post "/api/orders", params: valid_params, as: :json
        }.to change(Order, :count).by(1)
         .and change(Ticket, :count).by(2)

        ticket_tier.reload
        expect(ticket_tier.remaining).to eq(8)
        expect(response).to have_http_status(:created)
        
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Order created successfully")
      end
    end

    context "when tickets are insufficient" do
      it "returns unprocessable entity and does not create an order" do

        post "/api/orders", params: { event_id: event.id, ticket_tier_id: ticket_tier.id, quantity: 11 }, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.count).to eq(0)
      end
    end
  end

  describe "PATCH /api/orders/:id/cancel" do
    let!(:order) { create(:order, participant: participant, event: event, status: "confirmed") }
    let!(:ticket) { create(:ticket, order: order, ticket_tier: ticket_tier) }

    context "when the owner cancels the order" do
      it "updates status to cancelled and restocks tickets" do
        initial_remaining = ticket_tier.remaining
        
        
        patch "/api/orders/#{order.id}/cancel", as: :json
        
        expect(response).to have_http_status(:ok)
        expect(order.reload.status).to eq("cancelled")
        expect(ticket_tier.reload.remaining).to eq(initial_remaining + 1)
      end
    end

    context "when another user tries to cancel" do
      let(:other_user) { create(:user, :for_participant) }
      let(:other_token) { double(resource_owner_id: other_user.id, accessible?: true) }

      it "returns unauthorized" do
        
        allow_any_instance_of(Api::BaseController).to receive(:doorkeeper_token).and_return(other_token)
        allow_any_instance_of(Api::OrdersController).to receive(:api_authorize_participant!).and_wrap_original do |method, *args|
          method.receiver.instance_variable_set(:@current_participant, other_user.userable)
          true
        end

        
        patch "/api/orders/#{order.id}/cancel", as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/my-tickets" do
    it "returns the current participant's orders" do
      create(:order, participant: participant)
      
      
      get "/api/my-tickets", as: :json
      
      expect(response).to have_http_status(:ok)
    end
  end
end