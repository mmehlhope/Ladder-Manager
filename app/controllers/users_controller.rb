class UsersController < ApplicationController
  require 'securerandom'

  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    # Assign or create organization
    if current_org
      @organization = current_org
    else
      @organization = Organization.create(org_params)
    end
    params = user_params
    params[:organization_id] = @organization.id

    # Users created from the admin panel won't have a password.
    if params[:password].blank?
      password = create_random_password
      params[:password] = params[:password_confirmation] = password
    end

    @user = User.new(params)

    respond_to do |format|
      if @user.save
        if @organization.has_lone_admin?
          LadderMailer.welcome_email(@user).deliver
        end
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

end
