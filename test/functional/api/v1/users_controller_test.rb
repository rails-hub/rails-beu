require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @api_v1_user = api_v1_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_v1_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_v1_user" do
    assert_difference('Api::V1::User.count') do
      post :create, api_v1_user: {  }
    end

    assert_redirected_to api_v1_user_path(assigns(:api_v1_user))
  end

  test "should show api_v1_user" do
    get :show, id: @api_v1_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_v1_user
    assert_response :success
  end

  test "should update api_v1_user" do
    put :update, id: @api_v1_user, api_v1_user: {  }
    assert_redirected_to api_v1_user_path(assigns(:api_v1_user))
  end

  test "should destroy api_v1_user" do
    assert_difference('Api::V1::User.count', -1) do
      delete :destroy, id: @api_v1_user
    end

    assert_redirected_to api_v1_users_path
  end
end
