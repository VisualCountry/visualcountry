require 'test_helper'

class SocialProfilesConnectionControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
