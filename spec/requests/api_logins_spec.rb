require 'rails_helper'

RSpec.describe "ApiLogins", type: :request do
  let(:email) { "user@example.com" }
  let(:password) { "password123" }
  let(:oauth_url) { "http://localhost:3000/oauth/token" }

  describe "POST /create" do
    context "when OAuth authentication is successful" do
      before do
        stub_request(:post, oauth_url).to_return(
          status: 200,
          body: { access_token: "fake_token_abc_123" }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it "redirects to organizer dashboard if user is an organizer" do
        user = create(:user, email: email, userable: create(:organizer))
        
        post api_login_path, params: { email: email, username: email, password: password }

        expect(session[:access_token]).to eq("fake_token_abc_123")
        expect(response).to redirect_to(organizer_dashboards_path)
      end

      it "redirects to participant dashboard if user is not an organizer" do
        user = create(:user, email: email, userable: create(:participant))
        
        post api_login_path, params: { email: email, username: email, password: password }

        expect(response).to redirect_to(participant_dashboards_path)
      end
    end

    context "when OAuth authentication fails" do
      before do
        # Mocking a failed HTTParty response
        stub_request(:post, oauth_url).to_return(status: 401)
      end

      it "redirects to login path with an alert" do
        post api_login_path, params: { email: email, username: email, password: password }

        expect(session[:access_token]).to be_nil
        expect(response).to redirect_to(api_login_path)
        expect(flash[:alert]).to eq("invalid email or password")
      end
    end
  end

  describe "DELETE /destroy" do
    it "clears the session and redirects to login" do
      # Pre-set the session
      post api_login_path, params: { email: email, password: password } 
      
      delete api_logout_path # Use the path helper for your logout route
      
      expect(session[:access_token]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq("Logged out!")
    end
  end
end