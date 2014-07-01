class GameSerializer < ApplicationSerializer
  self.root = false

  def attributes
    hash = super
    hash[:id]           = object.id
    hash[:date_created] = date_created
    hash[:last_updated] = updated_how_long_ago
    hash[:match_id] = object.match_id
    hash[:winner_id] = object.winner_id
    hash[:competitor_1_score] = object.competitor_1_score
    hash[:competitor_2_score] = object.competitor_2_score
    hash[:can_edit] = scope ? scope.can_edit_game?(object) : false
    hash
  end
end
