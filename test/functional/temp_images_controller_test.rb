require 'test_helper'

class TempImagesControllerTest < ActionController::TestCase
  setup do
    @temp_image = temp_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temp_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temp_image" do
    assert_difference('TempImage.count') do
      post :create, temp_image: {  }
    end

    assert_redirected_to temp_image_path(assigns(:temp_image))
  end

  test "should show temp_image" do
    get :show, id: @temp_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @temp_image
    assert_response :success
  end

  test "should update temp_image" do
    put :update, id: @temp_image, temp_image: {  }
    assert_redirected_to temp_image_path(assigns(:temp_image))
  end

  test "should destroy temp_image" do
    assert_difference('TempImage.count', -1) do
      delete :destroy, id: @temp_image
    end

    assert_redirected_to temp_images_path
  end
end
