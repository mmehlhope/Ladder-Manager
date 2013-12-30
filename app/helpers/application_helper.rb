module ApplicationHelper

  def flash_message?
    true if flash[:notice] || flash[:alert] || flash[:error] || flash[:success]
  end

end
