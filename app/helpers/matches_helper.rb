module MatchesHelper

  ######################
  # COMPETITOR HELPERS #
  ######################

  def get_competitor_1
    Competitor.find_by_id(competitor_1)
  end
  
  def get_competitor_2
    Competitor.find_by_id(competitor_2)
  end

  def winning_competitor
    Competitor.find_by_id(winner_id)
  end

  def losing_competitor
    competitors = [competitor_1, competitor_2]
    id = competitors.reject { |id| id == winner_id }.try(:first)
    Competitor.find_by_id(id)
  end
  
  #################
  # STATE HELPERS #
  #################

  def finalized?
    finalized
  end

end