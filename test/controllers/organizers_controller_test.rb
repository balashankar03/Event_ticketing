require "test_helper"

class OrganizersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organizers_index_url
    assert_response :success
  end

  test "should get show" do
    get organizers_show_url
    assert_response :success
  end

  test "should get new" do
    get organizers_new_url
    assert_response :success
  end

  test "should get create" do
    get organizers_create_url
    assert_response :success
  end

  test "should get edit" do
    get organizers_edit_url
    assert_response :success
  end

  test "should get update" do
    get organizers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get organizers_destroy_url
    assert_response :success
  end
end
