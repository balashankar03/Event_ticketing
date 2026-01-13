require "test_helper"

class Organizer::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get organizer_dashboards_show_url
    assert_response :success
  end
end
