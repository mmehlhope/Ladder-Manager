class LadderSerializer < ApplicationSerializer

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:name]              = object.name
    hash[:organization_id]   = object.organization_id

    if options[:expanded]
      hash[:competitors] = ActiveModel::ArraySerializer.new(
                            object.competitors,
                            each_serializer:
                            CompetitorSerializer)
      hash[:matches]     = ActiveModel::ArraySerializer.new(
                            object.matches,
                            each_serializer:
                            MatchSerializer,
                            minimal: true)
    end

    hash
  end
end