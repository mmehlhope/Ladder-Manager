module ApplicationHelper

  def flash_message?
    true if flash[:notice] || flash[:alert] || flash[:error] || flash[:success]
  end

  def ensure_user_can_admin_ladder
    unless user_can_admin_ladder
      flash[:error] = "Please sign in as the administrator to modify the ladder."
      redirect_to ladder_path(@ladder)
    end
  end
  def user_can_admin_ladder
    unless @ladder.nil?
      session[:user_can_admin].try(:include?, @ladder.id)
    else
      false
    end
  end

end
