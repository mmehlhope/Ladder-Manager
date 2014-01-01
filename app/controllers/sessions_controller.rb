class SessionsController < ApplicationController
  before_action :set_ladder

  def create
    if @ladder && @ladder.authenticate(params[:password])
      session[:user_can_admin] = [@ladder.id]
      flash[:success] = "You have been successfully logged in."
    else
      flash[:error] = "The password you entered was invalid."
    end
    redirect_to ladder_path(@ladder)
  end

  def destroy
    session[:user_can_admin] = nil
    flash[:success] = "You have been successfully logged out."
    redirect_to ladder_path(@ladder)
  end

  private

    def set_ladder
      id = params[:id] ||= params[:ladder_id]
      @ladder = Ladder.find_by_id(id)
    end
end
