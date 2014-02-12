class MatchSerializer < ApplicationSerializer

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:competitor_1]      = CompetitorSerializer.new(Competitor.find_by_id(object.competitor_1), root: false)
    hash[:competitor_2]      = CompetitorSerializer.new(Competitor.find_by_id(object.competitor_2), root: false)
    hash[:date_created]      = date_created
    hash[:finalized]         = object.finalized
    hash[:last_updated]      = updated_how_long_ago
    hash[:winner_id]         = object.winner_id

    if options[:expanded]
      hash[:ladder] = {
        ladder_id: object.ladder_id,
        ladder_name: object.ladder.name
      }
      hash[:games] = ActiveModel::ArraySerializer.new(object.games, each_serializer: GameSerializer)
    end
    hash
  end
end
