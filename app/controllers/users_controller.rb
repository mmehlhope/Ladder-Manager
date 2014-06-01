class UsersController < ApplicationController
  require 'securerandom'

  before_action :authenticate_user!
  before_action :set_user, :except => [:index]

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.json {
        render json: User.all
      }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.json {
        render json: @user
      }
    end
  end

  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
