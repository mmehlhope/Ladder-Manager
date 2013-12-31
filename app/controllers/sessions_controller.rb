class SessionsController < ApplicationController
  before_action :set_ladder

  def new
  end

  def create
    if @ladder && @ladder.authenticate(params[:password])
      session[:user_can_admin] = [@ladder.id]
    else
      flash[:error] = "Invalid password"
    end
    redirect_to ladder_path(@ladder)
  end

  def destroy
    session[:user_can_admin] = nil
    redirect_to ladder_path(@ladder)
  end

  private

    def set_ladder
      @ladder = Ladder.find_by_id(params[:ladder_id])
    end
end
