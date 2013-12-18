require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase

  test "increment win count" do
    competitor = Competitor.new
    assert_equal(0, competitor.wins, "Competitor has no wins")

    competitor.increment_win_count
    assert_equal(1, competitor.wins, "Competitor has 1 win")
  end

  test "reduce win count" do
    competitor = Competitor.new(:wins => 1)
    assert_equal(1, competitor.wins, "Competitor has 1 win")

    competitor.reduce_win_count
    assert_equal(0, competitor.wins, "Competitor has no wins")
  end

  test "update rating" do
    competitor = Competitor.new(:rating => 1000)
    assert_equal(1000, competitor.rating,  "Competitor has a rating of 1000")

    competitor.update_rating(1200)
    assert_equal(1200, competitor.rating, "Competitor's rating updated")
  end
end
