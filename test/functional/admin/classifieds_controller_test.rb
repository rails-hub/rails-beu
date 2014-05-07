require 'test_helper'

class Admin::ClassifiedsControllerTest < ActionController::TestCase
  setup do
    @admin_classified = admin_classifieds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_classifieds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_classified" do
    assert_difference('Admin::Classified.count') do
      post :create, admin_classified: { classified_category_id: @admin_classified.classified_category_id, isactive: @admin_classified.isactive, name: @admin_classified.name }
    end

    assert_redirected_to admin_classified_path(assigns(:admin_classified))
  end

  test "should show admin_classified" do
    get :show, id: @admin_classified
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_classified
    assert_response :success
  end

  test "should update admin_classified" do
    put :update, id: @admin_classified, admin_classified: { classified_category_id: @admin_classified.classified_category_id, isactive: @admin_classified.isactive, name: @admin_classified.name }
    assert_redirected_to admin_classified_path(assigns(:admin_classified))
  end

  test "should destroy admin_classified" do
    assert_difference('Admin::Classified.count', -1) do
      delete :destroy, id: @admin_classified
    end

    assert_redirected_to admin_classifieds_path
  end
end
