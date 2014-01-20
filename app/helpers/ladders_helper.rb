module LaddersHelper

  def highest_competitor
    rating_desc.try(:first)
  end

  def rating_desc
    competitors.order("rating desc")
  end

  def has_competitors?
    competitors.size > 0
  end

  def has_matches?
    matches.size > 0
  end

  def can_record_match?
    competitors.size >= 2
  end
end
