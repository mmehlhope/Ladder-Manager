class Match < ActiveRecord::Base
  belongs_to              :ladder
  has_many                :games, dependent: :destroy
  has_and_belongs_to_many :competitors

  include MatchesHelper

  # Parses a match's series of games, pulling the winner IDs from each
  # game. If there is more than one winner and and they have not won the
  # same number of games, the winner id is returned. Also, if there is only
  # one winner, that winner id is returned. Otherwise, there is no clear
  # winner in the series (yet).
  def determine_match_winner
    # CURRENTLY ASSUMES ONLY TWO COMPETITOR IDS
    winners = games.collect { |game| game.winner_id }.compact # [1,2,2,2,1]
    wins    = winners.group_by { |e| e }.values               # [[1,1], [2,2,2]]

    if (wins.length > 1 && wins[0].length != wins[1].length) || wins.length == 1
      ret = wins.max_by(&:size).try(:first)
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
    winning_id = determine_match_winner unless !winning_id.blank?

    update(:winner_id => winning_id)
  end

  # Currently assumes a winner and a loser. The winner has their win count
  # incremeneted, while bothplayers have their new ELOs calculated
  def update_player_stats
    winning_competitor.increment_win_count
    winning_elo = winning_competitor.calculate_elo(losing_competitor.rating, 1)
    losing_elo  = losing_competitor.calculate_elo(winning_competitor.rating, 0)

    winning_competitor.update_rating(winning_elo) unless winning_elo.blank?
    losing_competitor.update_rating(losing_elo) unless losing_elo.blank?
  end
end


