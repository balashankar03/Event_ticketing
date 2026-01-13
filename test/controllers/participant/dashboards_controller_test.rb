require "test_helper"

class Participant::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get participant_dashboards_show_url
    assert_response :success
  end
end
