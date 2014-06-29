class LadderSerializer < ApplicationSerializer
  self.root = false

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:name]              = object.name
    hash[:organization_id]   = object.organization_id
    hash[:competitor_count]  = object.competitors.size
    hash[:matches_count]     = object.matches.size
    hash[:can_edit] = scope ? scope.can_edit_ladder?(object) : false

    if options[:expanded]
      hash[:competitors] = ActiveModel::ArraySerializer.new(
                            object.competitors,
                            each_serializer: CompetitorSerializer,
                            scope: scope)
      hash[:matches]     = ActiveModel::ArraySerializer.new(
                            object.matches,
                            each_serializer: MatchSerializer,
                            scope: scope,
                            minimal: true)
    end
    hash
  end
end
