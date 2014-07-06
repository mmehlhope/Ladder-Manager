class DashboardController < ApplicationController
  before_action :verify_user

  def index
    @user = current_user
  end

  private

    def verify_user
      if current_user.nil?
        redirect_with_error("You must first login to see your dashboard", login_path)
      end
    end
end
