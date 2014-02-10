require_relative '../test_helper'

class LandscapesControllerTest < ActionController::TestCase

  setup do
    @landscape = landscapes(:one)
    @landscape.update_attributes(picture: Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/matterhorn.jpg", 'image/jpg'))
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
      post :create, landscape: { name: @landscape.name, picture: Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/matterhorn.jpg", 'image/jpg')}
    end
    assert_response :success
    assert_template :crop
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
    put :update, id: @landscape, landscape: { name: 'Updated Name' }
    assert_response :redirect
  end

  test "should destroy landscape" do
    assert_difference('Landscape.count', -1) do
      delete :destroy, id: @landscape
    end

    assert_redirected_to landscapes_path
  end
end
