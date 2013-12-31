module ApplicationHelper

  def flash_message?
    true if flash[:notice] || flash[:alert] || flash[:error] || flash[:success]
  end

  def user_can_admin_ladder
    unless @ladder.nil?
      session[:user_can_admin].try(:include?, @ladder.id)
    else
      false
    end
  end

end
