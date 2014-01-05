require 'test_helper'

class LaddersControllerTest < ActionController::TestCase
  setup do
    @ladder = ladders(:ladder_one)
    @c1     = competitors(:competitor_one)
    @c2     = competitors(:competitor_two)
    session[:user_can_admin] = [@ladder.id]
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
      post :create, ladder: {
        name: @ladder.name,
        admin_email: "test@test.com",
        competitor_1: @c1.id,
        competitor_1: @c2.id,
        password: "test",
        password_confirmation: "test"
      }
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

  test "should change admin password" do
    patch :update, id: @ladder, ladder: { password: 'test', password_confirmation: 'test'}
    assert_equal flash[:success], "Admin preferences have been successfully updated.", "Admin preferences success message"
    assert_redirected_to ladder_path(assigns(:ladder))
  end

  test "should not change admin password" do
    patch :update, id: @ladder, ladder: { password: 'test', password_confirmation: 'tacos'}
    assert assigns(:ladder).errors.size == 1
    assert_template 'admin_preferences', 'Admin preferences was rendered'
  end

  test "should destroy ladder" do
    assert_difference('Ladder.count', -1) do
      delete :destroy, id: @ladder
    end

    assert_redirected_to root_path
  end
end
