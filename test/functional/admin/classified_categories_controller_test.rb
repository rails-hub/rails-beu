require 'test_helper'

class Admin::ClassifiedCategoriesControllerTest < ActionController::TestCase
  setup do
    @admin_classified_category = admin_classified_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_classified_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_classified_category" do
    assert_difference('Admin::ClassifiedCategory.count') do
      post :create, admin_classified_category: { name: @admin_classified_category.name, parent_category_id: @admin_classified_category.parent_category_id }
    end

    assert_redirected_to admin_classified_category_path(assigns(:admin_classified_category))
  end

  test "should show admin_classified_category" do
    get :show, id: @admin_classified_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_classified_category
    assert_response :success
  end

  test "should update admin_classified_category" do
    put :update, id: @admin_classified_category, admin_classified_category: { name: @admin_classified_category.name, parent_category_id: @admin_classified_category.parent_category_id }
    assert_redirected_to admin_classified_category_path(assigns(:admin_classified_category))
  end

  test "should destroy admin_classified_category" do
    assert_difference('Admin::ClassifiedCategory.count', -1) do
      delete :destroy, id: @admin_classified_category
    end

    assert_redirected_to admin_classified_categories_path
  end
end
