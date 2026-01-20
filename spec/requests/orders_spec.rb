require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:participant) { create(:participant) }
  let!(:user) { create(:user, userable: participant) }
  
  let(:other_participant) { create(:participant) }
  let(:other_user) { create(:user, userable: other_participant) }

  describe "GET /index" do
    context "when authorized" do
      before do
        sign_in user
      end

      it "renders the index page successfully" do

        create(:order, participant: participant, :with_tickets)
        
        get participant_orders_path(participant_id: participant.id)
        expect(response).to have_http_status(:ok)
      end

      it "redirects with 'Unauthorized' if the ID does not match the logged-in user" do
        
        get participant_orders_path(participant_id: 0)
        
        expect(response).to redirect_to(root_path)
        
      end
    end

    context "when unauthorized" do
      before { sign_in other_user }

      it "redirects to root if trying to access another participant's page" do
        get participant_orders_path(participant_id: participant.id)
        
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Unauthorized")
      end
    end
  end

  describe "GET /show" do
    let(:order) { create(:order, participant: participant) }

    it "renders the order show page successfully" do
      create(:ticket, order: order)
      
      get order_path(order)
      
      expect(response).to have_http_status(:ok)

      expect(assigns(:order)).to eq(order)
    end
  end
end