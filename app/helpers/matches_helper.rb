module MatchesHelper
  include ActionView::Helpers::DateHelper

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

  def competitor_1_is_winner?
    competitor_1 == winner_id
  end

  def competitor_2_is_winner?
    competitor_2 == winner_id
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

  ##################
  # STRING HELPERS #
  ##################

  def updated_how_long_ago
    "#{distance_of_time_in_words(Time.now, updated_at).capitalize} ago"
  end

  def date_created
    updated_at.strftime("%B %d, %Y")
  end
end