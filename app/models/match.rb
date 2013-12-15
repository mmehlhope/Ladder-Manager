class Match < ActiveRecord::Base
  has_many :games, dependent: :destroy
  belongs_to :ladder

  include MatchesHelper

  # Parses a match's series of games, pulling the winner IDs from each
  # game. If there is more than one winner and and they have not won the
  # same number of games, the winner id is returned. Also, if there is only
  # one winner, that winner id is returned. Otherwise, there is no clear
  # winner in the series (yet).
  def determine_match_winner
    # CURRENTLY ASSUMES ONLY TWO COMPETITOR IDS
    winners = games.collect { |game| game.winner_id } # [1,2,2,2,1]
    wins    = winners.group_by { |e| e }.values       # [[1,1], [2,2,2]]

    if (wins.length > 1 && wins[0].size != wins[1].size) || wins.length == 1
      ret = wins.max_by(&:size).try(:first)
    else
      ret = nil
    end

    ret
  end

  # Finalizes the match so that no more games can be added/edited
  def finalize(bool=true)
    update_attributes(:finalized => bool)
  end

  # Updates the match's overall winner, using determine_match_winner as
  # a helper to decide. Called every time a game is saved.
  def update_current_match_winner
    competitor_id = determine_match_winner
    update_attributes({:winner_id => competitor_id})
  end

  # Currently assumes a winner and a loser. The winner has their win count
  # incremeneted, while bothplayers have their new ELOs calculated
  def update_player_stats
    winning_competitor.increment_win_count
    winning_competitor.calculate_elo(losing_competitor.rating, 1)
    losing_competitor.calculate_elo(winning_competitor.rating, 0)
  end
end


      