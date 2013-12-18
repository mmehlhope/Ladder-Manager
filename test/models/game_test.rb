require 'test_helper'

class GameTest < ActiveSupport::TestCase

  setup do
    @game = games(:game_one)
    @match = matches(:match_one)
    c1 = competitors(:competitor_one)
    c2 = competitors(:competitor_two)
    @match.competitors << [c1, c2]
  end

  test "should populate match winner id" do
    game = @game
    assert_equal nil, game.winner_id, "Winner ID is nil by default"

    # Saving calls game.populate_winner, which should populate the winner_id
    game.update_attributes({
      competitor_1_score: 1,
      competitor_2_score: 0
    })
    assert_equal @match.get_competitor_1.id, game.winner_id, "Game winner is competitor 1"
  end

  test "should return nil for winner_id in case of tie" do
    game = @game
    assert_equal nil, game.winner_id, "Winner ID is nil by default"

    # Saving calls game.populate_winner, which should populate the winner_id
    game.update_attributes({
      competitor_1_score: 1,
      competitor_2_score: 1
    })
    assert_equal nil, game.winner_id, "Game winner is nil because of tie"
  end

  test "should alter match winner_id because of game deletion" do
    game = @game
    assert_equal nil, game.winner_id, "Winner ID is nil by default"

    # Saving calls game.populate_winner, which should populate the winner_id
    game.update_attributes({
      competitor_1_score: 1,
      competitor_2_score: 0
    })
    assert_equal @match.get_competitor_1.id, game.winner_id, "Game winner is competitor 1"
    # Destroying a game updates the match's current winner_id
    game.destroy
    assert_equal nil, @match.winner_id, "Deletion of only game caused winner_id to return to nil"
  end
end
