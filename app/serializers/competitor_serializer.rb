class CompetitorSerializer < ApplicationSerializer
  self.root = false

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:name]              = object.name
    hash[:rating]            = object.rating
    hash[:wins]              = object.wins
    hash[:errors]            = object.errors
    hash[:has_unfinished_matches] = object.has_unfinished_matches?

    if options[:expanded]
      hash[:games]  = ActiveModel::ArraySerializer.new(object.games, each_serializer: GameSerializer)
      hash[:ladder] = LadderSerializer.new(object.ladder, root: false)
    end

    hash
  end
end
