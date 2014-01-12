module ApplicationHelper

  ################
  # User helpers #
  ################
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def ensure_user_can_admin_ladder
    unless user_can_admin_ladder
      flash[:error] = "Please login to edit the ladder."
      redirect_to login_path
    end
  end

  def user_can_admin_ladder
    # If user isn't logged in, clearly can't admin. If the user is logged in but the ladder
    # does not belong to them, they also cannot admin it.
    current_user.nil? ? false : (current_user.ladders.find_by_id(params[:id]).nil? ? false : true)
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
