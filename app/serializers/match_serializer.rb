class MatchSerializer < ActiveModel::Serializer
  has_many :games

  def attributes
    hash = super
    hash[:id] = object.id
    hash[:date_created]      = object.date_created
    hash[:last_updated]      = object.updated_how_long_ago
    hash[:winner_id]         = object.winner_id
    hash[:finalized]         = object.finalized
    hash[:competitor_1]      = {
      id: object.competitor_1,
      name: object.competitor_1_name,
    }
    hash[:competitor_2]      = {
      id: object.competitor_2,
      name: object.competitor_2_name,
    }
    hash[:ladder] = {
      ladder_id: object.ladder_id,
      ladder_name: object.ladder.name
    }
    hash
  end
end
