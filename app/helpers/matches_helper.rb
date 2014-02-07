module MatchesHelper

  ######################
  # COMPETITOR HELPERS #
  ######################

  def get_competitor_1
    competitors.find_by_id(competitor_1)
  end

  def get_competitor_2
    competitors.find_by_id(competitor_2)
  end

  def competitor_1_name
    get_competitor_1.try(:name) || "(deleted)"
  end

  def competitor_2_name
    get_competitor_2.try(:name) || "(deleted)"
  end

  def winning_competitor
    competitors.find_by_id(winner_id)
  end

  def losing_competitor
    competitors.where.not(id: winner_id).try(:first)
  end

  #################
  # STATE HELPERS #
  #################

  def has_games?
    games.size > 0
  end

  def finalized?
    finalized
  end

end