require 'rails_helper'

RSpec.describe "Organizers", type: :request do
  let(:organizer) { create(:organizer) }
  let!(:user) { create(:user, userable: organizer) }
  
  let(:other_organizer) { create(:organizer) }
  let(:other_user) { create(:user, userable: other_organizer) }

  describe "GET /show" do
    context "when logged in as the correct organizer" do
      before do
        sign_in user 
      end

      it "renders the show page successfully" do
        get organizer_path(organizer)
        expect(response).to have_http_status(:ok)

      end
    end

    context "when unauthorized" do
      before { sign_in other_user }

      it "redirects to root if trying to access another organizer's page" do
        get organizer_path(organizer)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when organizer does not exist" do
      before { sign_in user }

      it "redirects to root with an alert" do
        get organizer_path(id: 0)
        expect(flash[:alert]).to eq("Unauthorized access. Please log in as the correct Organizer.")
      end
    end
  end
end