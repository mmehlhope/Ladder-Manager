class Competitor < ActiveRecord::Base
  belongs_to :ladder
  has_many :matches

  include CompetitorsHelper
  include Elo

  def increment_win_count
    update_attributes({:wins => wins + 1})
  end

  def reduce_win_count
    update_attributes({:wins => wins - 1})
  end

  def update_rating(new_rating=nil)
    unless new_rating.nil?
      update_attributes(:rating => new_rating)
    end
  end

  def calculate_elo(opponents_rating, result)
    expected_score = get_expected_score(rating, opponents_rating)
    new_elo_rating = new_rating(expected_score, result, rating)
  end
end
