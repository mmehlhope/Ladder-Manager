require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  setup do
    @ladder = ladders(:ladder_one)
    @match = matches(:match_one)
    @c1 = competitors(:competitor_one)
    @c2 = competitors(:competitor_two)
    @match.competitors << [@c1,@c2]
  end

  test "should get index" do
    get :index, ladder_id: @ladder.id
    assert_response :success
    assert_not_nil assigns(:matches)
  end

  test "should get new" do
    get :new, ladder_id: @ladder.id
    assert_response :success
  end

  test "should create match" do
    assert_difference('Match.count') do
      post :create, match: {:competitor_1 => @c1.id, :competitor_2 => @c2.id}, ladder_id: @ladder.id
    end
    assert_redirected_to match_path(Match.last)
  end

  test "should show match" do
    get :show, id: @match, ladder_id: @ladder.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @match, ladder_id: @ladder.id
    assert_response :success
  end

  test "should update match" do
    patch :update, id: @match, match: {  }
    assert_redirected_to match_path(assigns(:match))
  end

  test "should destroy match" do
    assert_difference('Match.count', -1) do
      delete :destroy, id: @match, ladder_id: @ladder.id
    end

    assert_redirected_to ladder_matches_path(@ladder)
  end
end
