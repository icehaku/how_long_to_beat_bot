require 'test_helper'

class TelegramControllerTest < ActionDispatch::IntegrationTest
  test "should get hi" do
    get "/hi"
    assert_response :success
  end
end
