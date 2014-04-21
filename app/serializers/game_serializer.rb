class GameSerializer < ApplicationSerializer
  self.root = false

  attributes :id, :date_created, :updated_how_long_ago, :match_id, :winner_id,
             :competitor_1_score, :competitor_2_score
end
