module OrganizationHelper

  def has_ladders?
    ladders.size > 0
  end

  ################
  # DATA HELPERS #
  ################

  def ladders_json
    ActiveModel::ArraySerializer.new(
      ladders,
      each_serializer:
      LadderSerializer
    ).to_json
  end

end
