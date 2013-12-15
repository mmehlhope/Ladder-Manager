require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase
  
  test "increment_win_count" do
    competitor = Competitor.new
    assert_equal(competitor.wins, 0, "Competitor has no wins")

    competitor.increment_win_count
    assert_equal(competitor.wins, 1, "Competitor has 1 win")
  end

  test "reduce_win_count" do
    competitor = Competitor.new(:wins => 1)
    assert_equal(competitor.wins, 1, "Competitor has 1 win")

    competitor.reduce_win_count
    assert_equal(competitor.wins, 0, "Competitor has no wins")
  end
end
