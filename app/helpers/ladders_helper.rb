module LaddersHelper

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
