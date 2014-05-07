require 'test_helper'

class TargetRulesControllerTest < ActionController::TestCase
  setup do
    @target_rule = target_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:target_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create target_rule" do
    assert_difference('TargetRule.count') do
      post :create, target_rule: { age_category: @target_rule.age_category, all: @target_rule.all, birthday: @target_rule.birthday, end_date: @target_rule.end_date, gender: @target_rule.gender, past_customer: @target_rule.past_customer, start_date: @target_rule.start_date, title: @target_rule.title }
    end

    assert_redirected_to target_rule_path(assigns(:target_rule))
  end

  test "should show target_rule" do
    get :show, id: @target_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @target_rule
    assert_response :success
  end

  test "should update target_rule" do
    put :update, id: @target_rule, target_rule: { age_category: @target_rule.age_category, all: @target_rule.all, birthday: @target_rule.birthday, end_date: @target_rule.end_date, gender: @target_rule.gender, past_customer: @target_rule.past_customer, start_date: @target_rule.start_date, title: @target_rule.title }
    assert_redirected_to target_rule_path(assigns(:target_rule))
  end

  test "should destroy target_rule" do
    assert_difference('TargetRule.count', -1) do
      delete :destroy, id: @target_rule
    end

    assert_redirected_to target_rules_path
  end
end
