require 'test_helper'

class LaddersControllerTest < ActionController::TestCase
  setup do
    @ladder = ladders(:ladder_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ladders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ladder" do
    assert_difference('Ladder.count') do
      post :create, ladder: { name: @ladder.name }
    end

    assert_redirected_to ladder_path(assigns(:ladder))
  end

  test "should show ladder" do
    get :show, id: @ladder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ladder
    assert_response :success
  end

  test "should update ladder" do
    patch :update, id: @ladder, ladder: { name: @ladder.name }
    assert_redirected_to ladder_path(assigns(:ladder))
  end

  test "should destroy ladder" do
    assert_difference('Ladder.count', -1) do
      delete :destroy, id: @ladder
    end

    assert_redirected_to ladders_path
  end
end
