require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) } 
  let(:other_user) { create(:user) }

  
  before do
    sign_in user 
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_path(user)
      expect(response).to be_successful
    
    end

    it "redirects if user is not found" do
      get user_path(id: '999')
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Unauthorized")
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "New Name", userable_attributes: {id: user.userable.id, city: "New York" } }
      }

      it "updates the requested user and redirects" do
        patch user_path(user), params: { user: new_attributes }
        user.reload
        expect(user.name).to eq("New Name")
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq("Profile updated successfully!")
      end
    end

    context "with invalid parameters" do
      it "renders the edit template (unprocessable_entity)" do
        
        patch user_path(user), params: { user: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "Authorization" do
    it "redirects an unauthorized user trying to edit someone else" do
      get edit_user_path(other_user)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Unauthorized")
    end
  end
end