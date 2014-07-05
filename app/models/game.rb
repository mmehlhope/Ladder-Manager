class Game < ActiveRecord::Base
  belongs_to :match
  has_and_belongs_to_many :competitors

  before_save   :populate_winner
  after_save    :update_match_winner
  after_destroy :update_match_winner

  validates :competitor_1_score, numericality: { only_integer: true }
  validates :competitor_2_score, numericality: { only_integer: true }

  validates_associated :match, message: "has reached the maximum number of allowed games. Email contact@laddermanager.com to request a higher limit"

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
