class GameSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :match_id, :winner_id, :competitor_1_score, :competitor_2_score
end
