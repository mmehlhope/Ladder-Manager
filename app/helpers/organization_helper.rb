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

  def users_json
    sorted_users = users.sort! { |x,y| x.full_name <=> y.full_name }

    ActiveModel::ArraySerializer.new(
      sorted_users,
      each_serializer:
      UserSerializer
    ).to_json
  end

end
