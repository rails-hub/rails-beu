require 'test_helper'

class DealsWizardsControllerTest < ActionController::TestCase
  setup do
    @deals_wizard = deals_wizards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deals_wizards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deals_wizard" do
    assert_difference('DealsWizard.count') do
      post :create, deals_wizard: { buy_offer: @deals_wizard.buy_offer, buy_units: @deals_wizard.buy_units, fixed_offer: @deals_wizard.fixed_offer, spend_amount: @deals_wizard.spend_amount, spend_offer: @deals_wizard.spend_offer }
    end

    assert_redirected_to deals_wizard_path(assigns(:deals_wizard))
  end

  test "should show deals_wizard" do
    get :show, id: @deals_wizard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deals_wizard
    assert_response :success
  end

  test "should update deals_wizard" do
    put :update, id: @deals_wizard, deals_wizard: { buy_offer: @deals_wizard.buy_offer, buy_units: @deals_wizard.buy_units, fixed_offer: @deals_wizard.fixed_offer, spend_amount: @deals_wizard.spend_amount, spend_offer: @deals_wizard.spend_offer }
    assert_redirected_to deals_wizard_path(assigns(:deals_wizard))
  end

  test "should destroy deals_wizard" do
    assert_difference('DealsWizard.count', -1) do
      delete :destroy, id: @deals_wizard
    end

    assert_redirected_to deals_wizards_path
  end
end
