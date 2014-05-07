require 'test_helper'

class Admin::BasesControllerTest < ActionController::TestCase
  setup do
    @admin_basis = admin_bases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_bases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_basis" do
    assert_difference('Admin::Base.count') do
      post :create, admin_basis: {  }
    end

    assert_redirected_to admin_basis_path(assigns(:admin_basis))
  end

  test "should show admin_basis" do
    get :show, id: @admin_basis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_basis
    assert_response :success
  end

  test "should update admin_basis" do
    put :update, id: @admin_basis, admin_basis: {  }
    assert_redirected_to admin_basis_path(assigns(:admin_basis))
  end

  test "should destroy admin_basis" do
    assert_difference('Admin::Base.count', -1) do
      delete :destroy, id: @admin_basis
    end

    assert_redirected_to admin_bases_path
  end
end
