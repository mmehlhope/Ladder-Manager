require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game   = games(:game_one)
    @match  = matches(:match_one)
    c1      = competitors(:competitor_one)
    c2      = competitors(:competitor_two)
    @match.competitors << [c1, c2]
  end

  test "should get index" do
    get :index, match_id: @match.id
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new, match_id: @match.id
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, game: {:competitor_1_score => 1, :competitor_2_score => 2}, match_id: @match.id
    end

    assert_redirected_to match_path(@match)
  end

  test "should show game" do
    get :show, id: @game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game
    assert_response :success
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, id: @game
    end

    assert_redirected_to match_path(@match)
  end
end
