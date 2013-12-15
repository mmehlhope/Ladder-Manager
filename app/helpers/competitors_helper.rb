module CompetitorsHelper

  #######################
  # ASSOCIATION HELPERS #
  #######################

  def ladder
    ladder = Ladder.find_by_id(ladder_id)
  end

  def matches
    matches = ladder.matches.where("competitor_1 = ? OR competitor_2 = ?", id, id)
  end

  def games
    competitor_matches = matches
    games = competitor_matches.collect { |match| match.games }
  end

  ################
  # STAT HELPERS #
  ################

  def matches_played
    matches.select {|match| match.finalized?}.count
  end
  
  def games_played
    games.count
  end

  def losses
    matches_played - wins
  end
end
