require 'test_helper'

class CompaignObjectiveControllerTest < ActionController::TestCase
  test "should get name:string" do
    get :name:string
    assert_response :success
  end

end
