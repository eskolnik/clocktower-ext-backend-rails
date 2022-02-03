require "test_helper"

class GameSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get game_sessions_index_url
    assert_response :success
  end

  test "should get create" do
    get game_sessions_create_url
    assert_response :success
  end

  test "should get update" do
    get game_sessions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get game_sessions_destroy_url
    assert_response :success
  end

  test "should get show" do
    get game_sessions_show_url
    assert_response :success
  end
end
