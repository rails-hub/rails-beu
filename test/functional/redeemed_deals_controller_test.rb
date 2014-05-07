require 'test_helper'

class RedeemedDealsControllerTest < ActionController::TestCase
  setup do
    @redeemed_deal = redeemed_deals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:redeemed_deals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create redeemed_deal" do
    assert_difference('RedeemedDeal.count') do
      post :create, redeemed_deal: { deal_id: @redeemed_deal.deal_id, user_id: @redeemed_deal.user_id }
    end

    assert_redirected_to redeemed_deal_path(assigns(:redeemed_deal))
  end

  test "should show redeemed_deal" do
    get :show, id: @redeemed_deal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @redeemed_deal
    assert_response :success
  end

  test "should update redeemed_deal" do
    put :update, id: @redeemed_deal, redeemed_deal: { deal_id: @redeemed_deal.deal_id, user_id: @redeemed_deal.user_id }
    assert_redirected_to redeemed_deal_path(assigns(:redeemed_deal))
  end

  test "should destroy redeemed_deal" do
    assert_difference('RedeemedDeal.count', -1) do
      delete :destroy, id: @redeemed_deal
    end

    assert_redirected_to redeemed_deals_path
  end
end
