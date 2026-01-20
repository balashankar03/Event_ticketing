require 'rails_helper'

RSpec.describe "Participants", type: :request do
  let(:participant) { create(:participant) }
  let!(:user) { create(:user, userable: participant) }
  
  let(:other_participant) { create(:participant) }
  let(:other_user) { create(:user, userable: other_participant) }

  before { sign_in user }

  describe "GET /index" do
    it "renders the index page and lists all participants" do
      
      participant
      other_participant
      
      get participants_path
      
      expect(response).to have_http_status(:ok)
      
    end
  end

  describe "GET /new" do
    it "renders the new template and initializes empty objects" do
      get new_participant_path
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    context "when logged in as the correct participant" do
      it "renders the show page successfully" do
        get participant_path(participant)
        expect(response).to have_http_status(:ok)
    
      end
    end

    context "when unauthorized" do
      before { sign_in other_user }

      it "redirects to root if trying to access another participant's page" do
        get participant_path(participant)
        expect(response).to redirect_to(root_path)
        
      end
    end

    context "when participant does not exist" do
      it "redirects to root with an alert" do
        get participant_path(id: 0)
        expect(flash[:alert]).to eq("participant not found") 
      end
    end
  end
end