require 'test_helper'

class MasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get masks_index_url
    assert_response :success
  end

end
