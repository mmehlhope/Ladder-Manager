class UsersController < ApplicationController
  require 'securerandom'

  before_action :authenticate_user!
  before_action :set_user, :except => [:index, :create]

  # GET /admin/users
  # GET /admin/users.json
  def index
    respond_to do |format|
      format.json {
        render json: User.all
      }
    end
  end

  def create
    generated_password = Devise.friendly_token.first(8)

    full_params = user_params
    full_params[:password] = generated_password

    @user = User.new(full_params)

    respond_to do |format|
      if @user.save
        send_invitation_email(@user, generated_password)
        format.json { render json: @user }
      else
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    respond_to do |format|
      format.json {
        render json: @user
      }
    end
  end

  def update
    # TODO: Security email validation.
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.json {
          render json: @user
        }
      else
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to current_org }
      format.json { render json: @organization }
    end
  end

  private
    def send_invitation_email(user, password)
      LadderMailer.invitation_email(user, password).deliver
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :organization_id)
    end
end
