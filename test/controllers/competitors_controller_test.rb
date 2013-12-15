require 'test_helper'

class CompetitorsControllerTest < ActionController::TestCase
  setup do
    @ladder = ladders(:ladder_one)
    @competitor = competitors(:competitor_one)
  end

  test "should get index" do
    get :index, ladder_id: @ladder.id
    assert_response :success
    assert_not_nil assigns(:competitors)
  end

  test "should get new" do
    get :new, ladder_id: @ladder.id
    assert_response :success
  end

  test "should create competitor" do
    assert_difference('Competitor.count') do
      post :create, competitor: { name: @competitor.name }, ladder_id: @ladder.id
    end

    assert_redirected_to ladder_path(@ladder)
  end

  test "should show competitor" do
    get :show, id: @competitor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @competitor
    assert_response :success
  end

  test "should update competitor" do
    patch :update, id: @competitor, competitor: { name: @competitor.name }
    assert_redirected_to competitor_path(assigns(:competitor))
  end

  test "should destroy competitor" do
    assert_difference('Competitor.count', -1) do
      delete :destroy, id: @competitor, ladder_id: @ladder.id
    end

    assert_redirected_to ladder_path(@ladder)
  end
end
