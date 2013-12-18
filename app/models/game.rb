class Game < ActiveRecord::Base
  belongs_to :match

  before_save   :populate_winner
  after_save    :update_match_winner
  after_destroy :update_match_winner


  private
    # Based on the scores of the game, a winner is decided
    # and their competitor id is set as the winner_id. This
    # happens before_save, so no update_attributes is called
    def populate_winner
      if competitor_1_score > competitor_2_score
        self.winner_id = match.get_competitor_1.id
      elsif competitor_1_score < competitor_2_score
        self.winner_id = match.get_competitor_2.id
      else
        self.winner_id = nil
      end
    end

    # After a game is saved, the parent match is updated with
    # a new overall winner (or nil if not yet decided)
    def update_match_winner
      match.set_current_match_winner
    end
end
