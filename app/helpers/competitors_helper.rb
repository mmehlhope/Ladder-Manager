module CompetitorsHelper

  #######################
  # ASSOCIATION HELPERS #
  #######################

  def games
    games = matches.collect(&:games)
  end

  ################
  # STAT HELPERS #
  ################

  def matches_played
    matches.select(&:finalized?).count
  end

  def games_played
    games.count
  end

  def losses
    matches_played - wins
  end
end
