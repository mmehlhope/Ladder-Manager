class SessionsController < ApplicationController
  before_action :set_user_by_email, only: [:create]

  def create
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path
    elsif @user && !@user.authenticate(params[:password])
      flash[:error] = "The password you entered was invalid."
      redirect_to login_path
    else
      flash[:error] = "A user with that email address was not found."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have been successfully logged out."
    redirect_to root_path
  end

  private

    def set_user_by_email
      email = params[:email]
      @user = User.find_by_email(email)
    end
end
