require 'test_helper'

class Api::V1::TargetRulesControllerTest < ActionController::TestCase
  setup do
    @api_v1_target_rule = api_v1_target_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_v1_target_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_v1_target_rule" do
    assert_difference('Api::V1::TargetRule.count') do
      post :create, api_v1_target_rule: {  }
    end

    assert_redirected_to api_v1_target_rule_path(assigns(:api_v1_target_rule))
  end

  test "should show api_v1_target_rule" do
    get :show, id: @api_v1_target_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_v1_target_rule
    assert_response :success
  end

  test "should update api_v1_target_rule" do
    put :update, id: @api_v1_target_rule, api_v1_target_rule: {  }
    assert_redirected_to api_v1_target_rule_path(assigns(:api_v1_target_rule))
  end

  test "should destroy api_v1_target_rule" do
    assert_difference('Api::V1::TargetRule.count', -1) do
      delete :destroy, id: @api_v1_target_rule
    end

    assert_redirected_to api_v1_target_rules_path
  end
end
