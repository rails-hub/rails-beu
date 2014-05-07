require 'test_helper'

class CreditCardInformationsControllerTest < ActionController::TestCase
  setup do
    @credit_card_information = credit_card_informations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:credit_card_informations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create credit_card_information" do
    assert_difference('CreditCardInformation.count') do
      post :create, credit_card_information: { card_number: @credit_card_information.card_number, expiry_date: @credit_card_information.expiry_date, name: @credit_card_information.name, response: @credit_card_information.response }
    end

    assert_redirected_to credit_card_information_path(assigns(:credit_card_information))
  end

  test "should show credit_card_information" do
    get :show, id: @credit_card_information
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @credit_card_information
    assert_response :success
  end

  test "should update credit_card_information" do
    put :update, id: @credit_card_information, credit_card_information: { card_number: @credit_card_information.card_number, expiry_date: @credit_card_information.expiry_date, name: @credit_card_information.name, response: @credit_card_information.response }
    assert_redirected_to credit_card_information_path(assigns(:credit_card_information))
  end

  test "should destroy credit_card_information" do
    assert_difference('CreditCardInformation.count', -1) do
      delete :destroy, id: @credit_card_information
    end

    assert_redirected_to credit_card_informations_path
  end
end
