module UsersHelper
  include ActionView::Helpers::DateHelper

  def full_name
    name || email
  end

  def signed_in_how_long_ago
    if last_sign_in_at
      "#{distance_of_time_in_words(Time.now, last_sign_in_at).capitalize} ago"
    else
      "never"
    end
  end

  def is_activated?
    confirmation_token.present?
  end

  def is_real?
    id.present?
  end 

  ###############################
  # User Access and Permissions #
  ###############################
 
  def can_create_user_in_organization?(organization_id)
    return false unless organization
    organization.id == organization_id
  end

  def can_create_ladder_in_organization?(organization_id)
    return false unless organization
    organization.id == organization_id
  end

  def can_create_match_in_ladder?(ladder_id)
    ladder_exists_in_org?(ladder_id)
  end

  def can_create_competitor_in_ladder?(ladder_id)  
    ladder_exists_in_org?(ladder_id)
  end

  def can_create_game_in_match?(match_id)
    return false unless organization
    ladder_id = Match.find_by_id(match_id).try(:ladder_id)
    organization.ladders.find_by_id(ladder_id).present?
  end
 
  def can_edit_organization?(org)
    return false unless organization
    organization.id == org.id
  end

  def can_edit_user?(user)
    return false unless organization
    organization.id == user.organization.id
  end

  def can_delete_user?(user)
    return false unless id && organization
    id != user.id && organization.id == user.organization.id
  end

  def can_edit_ladder?(ladder)
    ladder_exists_in_org?(ladder)
  end

  def can_edit_match?(match)
    ladder_exists_in_org?(match.ladder)
  end

  def can_edit_competitor?(competitor)
    ladder_exists_in_org?(competitor.ladder)
  end

  def can_edit_game?(game)
    ladder_exists_in_org?(game.match.ladder)
  end

  def can_view_organization?(org)
    return false unless organization
    organization.id == org.id
  end
  
  def ladder_exists_in_org?(ladder)
    return false unless organization && organization.ladders
    ladder_id = ladder.is_a?(Integer) ? ladder : ladder.try(:id)
    organization.ladders.find_by_id(ladder_id).present?
  end
end
