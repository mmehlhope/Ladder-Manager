class Competitor < ActiveRecord::Base
  belongs_to :ladder
  has_and_belongs_to_many :matches
  has_and_belongs_to_many :games


  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9  -]+\z/, message: "can only contain letters, numbers, spaces, and hyphens."
  }

  include CompetitorsHelper
  include Elo

  def increment_win_count
    update(:wins => wins + 1)
  end

  def increment_draw_count
    update(:draws => draws + 1)
  end

  def reduce_win_count
    update(:wins => wins - 1)
  end

  def update_rating(new_rating=nil)
    unless new_rating.nil?
      update(:rating => new_rating)
    end
  end

  def calculate_elo(opponents_rating, result)
    unless opponents_rating.blank? or result.blank?
      expected_score = get_expected_score(rating, opponents_rating)
      new_elo_rating = new_rating(expected_score, result, rating)
    else
      nil
    end
  end

end
