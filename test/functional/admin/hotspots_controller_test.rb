require 'test_helper'

class Admin::HotspotsControllerTest < ActionController::TestCase
  setup do
    @admin_hotspot = admin_hotspots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_hotspots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_hotspot" do
    assert_difference('Admin::Hotspot.count') do
      post :create, admin_hotspot: { address: @admin_hotspot.address, name: @admin_hotspot.name, zone_id: @admin_hotspot.zone_id }
    end

    assert_redirected_to admin_hotspot_path(assigns(:admin_hotspot))
  end

  test "should show admin_hotspot" do
    get :show, id: @admin_hotspot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_hotspot
    assert_response :success
  end

  test "should update admin_hotspot" do
    put :update, id: @admin_hotspot, admin_hotspot: { address: @admin_hotspot.address, name: @admin_hotspot.name, zone_id: @admin_hotspot.zone_id }
    assert_redirected_to admin_hotspot_path(assigns(:admin_hotspot))
  end

  test "should destroy admin_hotspot" do
    assert_difference('Admin::Hotspot.count', -1) do
      delete :destroy, id: @admin_hotspot
    end

    assert_redirected_to admin_hotspots_path
  end
end
