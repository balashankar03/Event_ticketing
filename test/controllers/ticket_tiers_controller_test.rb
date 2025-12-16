require "test_helper"

class TicketTiersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ticket_tiers_index_url
    assert_response :success
  end

  test "should get show" do
    get ticket_tiers_show_url
    assert_response :success
  end

  test "should get new" do
    get ticket_tiers_new_url
    assert_response :success
  end

  test "should get create" do
    get ticket_tiers_create_url
    assert_response :success
  end

  test "should get edit" do
    get ticket_tiers_edit_url
    assert_response :success
  end

  test "should get update" do
    get ticket_tiers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get ticket_tiers_destroy_url
    assert_response :success
  end
end
