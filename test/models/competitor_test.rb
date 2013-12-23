require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase

  test "should increment win count" do
    competitor = Competitor.new
    assert_equal 0, competitor.wins, "Competitor has no wins"

    competitor.increment_win_count
    assert_equal 1, competitor.wins, "Competitor has 1 win"
  end

  test "should reduce win count" do
    competitor = Competitor.new(:wins => 1)
    assert_equal 1, competitor.wins, "Competitor has 1 win"

    competitor.reduce_win_count
    assert_equal 0, competitor.wins, "Competitor has no wins"
  end

  test "should calculate winning player elo" do
    competitor = Competitor.new
    opponent   = Competitor.new(rating: 1100)
    assert_equal 1000, competitor.rating, "Competitor default rating"
    assert_equal 1100, opponent.rating, "Opponent default rating"
    # calculate new Elo rating for competitor victory
    new_rating = competitor.calculate_elo(opponent.rating, 1)
    assert_equal 1020, new_rating, "Competitor ELO increased"
  end

  test "should calculate losing player elo" do
    competitor = Competitor.new
    opponent   = Competitor.new(rating: 1100)
    assert_equal 1000, competitor.rating, "Competitor default rating"
    assert_equal 1100, opponent.rating, "Opponent default rating"
    # calculate new Elo rating for competitor victory
    new_rating = competitor.calculate_elo(opponent.rating, 0)
    assert_equal 988, new_rating, "Competitor ELO decreased"
  end

  test "should update competitor rating" do
    competitor = Competitor.new
    assert_equal 1000, competitor.rating,  "Competitor default rating"

    competitor.update_rating(1200)
    assert_equal 1200, competitor.rating, "Competitor's rating updated"
  end

  test "invalid competitor name should not save" do
    competitor = Competitor.new(name: "bob;exec()")
    assert !competitor.valid?
    assert !competitor.save
  end

  test "valid competitor name should save" do
    competitor = Competitor.new(name: "Steven12")
    assert competitor.valid?
    assert competitor.save
  end

end
