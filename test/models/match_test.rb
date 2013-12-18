require 'test_helper'

class MatchTest < ActiveSupport::TestCase

  setup do
    @match = matches(:match_one)
    c1 = competitors(:competitor_one)
    c2 = competitors(:competitor_two)
    @match.competitors << [c1, c2]
  end

  test "should changed finalized state" do
    assert_equal false, @match.finalized, "Default state of match finalization is false"
    @match.finalize(true)
    assert_equal true, @match.finalized, "Match has been finalized"
  end

  test "should return finalized state" do
    assert_equal false, @match.finalized, "Default state of match finalization is false"
    assert_equal false, @match.finalized?, "Method returns proper finalized state"
  end

  test "should get first competitor" do
    # Compare populating record via AR and via association
    competitor_1 = Competitor.find_by_id(@match.competitor_1)
    assert competitor_1.name == "Andrew", "Competitor 1's name is Andrew"

    populated_competitor = @match.get_competitor_1
    assert populated_competitor.name == "Andrew", "Populated competitor's name is also Andrew"
  end

  test "should get second competitor" do
    # Compare populating record via AR and via association
    competitor_2 = Competitor.find_by_id(@match.competitor_2)
    assert competitor_2.name == "Bob", "Competitor 1's name is Bob"

    populated_competitor = @match.get_competitor_2
    assert populated_competitor.name == "Bob", "Populated competitor's name is also Bob"
  end

  test "should set winning competitor" do
    assert_nil @match.winner_id, "Match does not have a default winner"

    @match.set_current_match_winner(@match.competitor_1)
    assert_not_nil @match.winner_id, "Match has a set winner"
    assert @match.winner_id == @match.competitor_1, "Match's winner is set to competitor 1"
  end

  test "should return winning competitor" do
    assert_nil @match.winner_id, "Match does not have a default winner"

    @match.set_current_match_winner(@match.competitor_1)
    assert_not_nil @match.winner_id, "Match has a set winner"
    assert_equal "Andrew", @match.winning_competitor.name, "Winning competitor returned and has the name of Andrew"
  end

  test "should return losing competitor" do
    assert_nil @match.winner_id, "Match does not have a default winner"

    @match.set_current_match_winner(@match.competitor_1)
    assert_not_nil @match.winner_id, "Match has a set winner"
    assert_not_equal "Andrew", @match.losing_competitor.name, "Losing competitor is not Andrew"
  end


end
