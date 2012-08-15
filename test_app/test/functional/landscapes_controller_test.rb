require 'test_helper'

class LandscapesControllerTest < ActionController::TestCase
  setup do
    @landscape = landscapes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:landscapes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create landscape" do
    assert_difference('Landscape.count') do
      post :create, landscape: { name: @landscape.name }
    end

    assert_redirected_to landscape_path(assigns(:landscape))
  end

  test "should show landscape" do
    get :show, id: @landscape
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @landscape
    assert_response :success
  end

  test "should update landscape" do
    put :update, id: @landscape, landscape: { name: @landscape.name }
    assert_redirected_to landscape_path(assigns(:landscape))
  end

  test "should destroy landscape" do
    assert_difference('Landscape.count', -1) do
      delete :destroy, id: @landscape
    end

    assert_redirected_to landscapes_path
  end
end
