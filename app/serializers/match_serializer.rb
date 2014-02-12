class MatchSerializer < ApplicationSerializer
  has_many :games

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:winner_id]         = object.winner_id
    hash[:finalized]         = object.finalized
    hash[:competitor_1] = CompetitorSerializer.new(Competitor.find_by_id(object.competitor_1))
    hash[:competitor_2] = CompetitorSerializer.new(Competitor.find_by_id(object.competitor_2))

    unless options[:expanded]
      hash[:ladder] = {
        ladder_id: object.ladder_id,
        ladder_name: object.ladder.name
      }
    end
    hash
  end
end
