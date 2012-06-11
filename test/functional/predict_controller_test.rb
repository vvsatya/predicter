require 'test_helper'

class PredictControllerTest < ActionController::TestCase
  test "should get init" do
    get :init
    assert_response :success
  end

  test "should get run" do
    get :run
    assert_response :success
  end

end
