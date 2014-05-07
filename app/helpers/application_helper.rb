module ApplicationHelper

  ################
  # User helpers #
  ################
  def current_org
    @current_organization ? @current_organization : (current_user ? current_user.organization : false)
  end

  def ensure_user_can_admin_ladder
    unless user_can_admin_ladder
      flash[:error] = "Please login to edit the ladder."
      redirect_to login_path
    end
  end

  def user_can_admin_ladder
    id = params[:id] || params[:ladder_id]
    # If user isn't logged in or ladder does not belong to that user's organization, no dice.
    current_user.nil? ? false : (current_org.ladders.find_by_id(id).nil? ? false : true)
  end

  def user_can_admin_match
    id = params[:id] || params[:match_id]
    match = Match.find_by_id(id)
    current_user.nil? ? false : (current_org.ladders.find_by_id(match.ladder.id).nil? ? false : true)
  end

  ####################
  # Redirect Helpers #
  ####################

  def redirect_with_error(error, path)
    error ||= "You do not have permission to view that page"
    path  ||= root_path
    flash[:error] = error
    redirect_to path
  end

  ##################
  # Global Helpers #
  ##################
  def flash_message?
    true if flash[:notice] || flash[:alert] || flash[:error] || flash[:success]
  end
end
