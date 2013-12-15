module Elo
  extend ActiveSupport::Concern
  
  ###################
  # ELO CALCUATIONS #
  ###################
  # http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details

  K_FACTOR = 32.0 # Assumes average rating is below 2100, TODO: Calculate dynamically

  def get_expected_score(player_rating, opponent_rating)
    1.0 / (1.0 + 10.0 ** ((opponent_rating.to_f - player_rating.to_f) / 400.0))
  end

  # New Rating is currently rounded to the nearest whole number. When users start seeing inflation
  # or deflation over MANY games, need to adjust this.
  def new_rating(expected_score, actual_score, current_rating)
    (current_rating.to_f + K_FACTOR * (actual_score.to_f - expected_score.to_f)).round(0)
  end

end