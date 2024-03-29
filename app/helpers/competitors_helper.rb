module CompetitorsHelper

  ################
  # STAT HELPERS #
  ################

  def last_match_played_date
    last_match_played.created_at
  end

  def last_match_played
    matches.last
  end

  def matches_played
    matches.select(&:finalized?).size
  end

  def games_played
    games.size
  end

  def losses
    matches_played - wins - draws
  end

  def percent_of_highest_competitor
    (rating.to_f / ladder.highest_competitor.rating * 100).round(2)
  end

  def has_unfinished_matches?
    matches.reject(&:finalized?).length > 0
  end
end
