class Match < ActiveRecord::Base
  belongs_to              :ladder
  has_many                :games, dependent: :destroy
  has_and_belongs_to_many :competitors

  validate :validate_competitors

  include MatchesHelper

  # Parses a match's series of games, pulling the winner IDs from each
  # game. If there is more than one winner and and they have not won the
  # same number of games, the winner id is returned. Also, if there is only
  # one winner, that winner id is returned. Otherwise, there is no clear
  # winner in the series (yet).
  def determine_match_winner
    # CURRENTLY ASSUMES ONLY TWO COMPETITOR IDS
    # debugger
    winner_ids = games.collect { |game| game.winner_id }.compact # [1,2,2,2,1]
    grouped_winner_ids = winner_ids.group_by { |e| e }.values # [[1,1], [2,2,2]]

    # One winner for all matches
    if grouped_winner_ids.length == 1
      ret = grouped_winner_ids[0][0]
    # multiple winners in multiple matches
    elsif grouped_winner_ids.length > 1
      if grouped_winner_ids[0].length != grouped_winner_ids[1].length
        ret = grouped_winner_ids.max_by(&:size).try(:first)
      else # No matches recorded or tie
        ret = nil
      end
    else
      ret = nil
    end
    ret
  end

  # Finalizes the match so that no more games can be added/edited
  def finalize(bool=true)
    update(:finalized => bool)
  end

  # Updates the match's overall winner, using determine_match_winner as
  # a helper to decide. Called every time a game is saved.
  def set_current_match_winner(winning_id=nil)
    winning_id ||= determine_match_winner
    update(:winner_id => winning_id)
  end

  def update_player_stats
    # In case of tie
    if winner_id.nil?
      # add a draw for each player
      competitors.each do |competitor|
        competitor.increment_draw_count
      end
      competitor_1_elo = get_competitor_1.calculate_elo(get_competitor_2.rating, 0.5)
      competitor_2_elo = get_competitor_2.calculate_elo(get_competitor_1.rating, 0.5)
      get_competitor_1.update_rating(competitor_1_elo)
      get_competitor_2.update_rating(competitor_2_elo)
    # Standard win/loss
    else
      winning_competitor.increment_win_count
      winning_elo = winning_competitor.calculate_elo(losing_competitor.rating, 1)
      losing_elo  = losing_competitor.calculate_elo(winning_competitor.rating, 0)
      winning_competitor.update_rating(winning_elo)
      losing_competitor.update_rating(losing_elo)
    end
  end

  protected

  def validate_competitors
    if competitor_1 == competitor_2
      errors[:base] << "A competitor cannot compete against him or herself. Please select a different opponent."
    elsif competitor_1.blank? || competitor_2.blank?
      errors[:base] << "Two unique competitors must be selected for the match."
    end
  end
end