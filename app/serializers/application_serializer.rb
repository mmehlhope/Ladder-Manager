class ApplicationSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  ##################
  # STRING HELPERS #
  ##################

  def updated_how_long_ago
    "#{distance_of_time_in_words(Time.now, object.updated_at).capitalize} ago"
  end

  def date_created
    object.updated_at.strftime("%B %d, %Y")
  end

end
