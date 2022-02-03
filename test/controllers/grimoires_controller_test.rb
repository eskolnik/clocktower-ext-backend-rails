require "test_helper"

class GrimoiresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grimoires_index_url
    assert_response :success
  end
end
