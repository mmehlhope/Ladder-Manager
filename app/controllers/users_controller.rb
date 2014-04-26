class UsersController < ApplicationController
  before_action :set_user, only: [:login, :show, :edit, :update, :destroy]
  before_action :verify_user, except: [:login, :new, :create, :show]

  # GET /login
  def login
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if current_org
      @organization = current_org
    else
      @organization = Organization.create(org_params)
    end
    params = user_params
    params[:organization_id] = @organization.id
    @user = User.new(params)

    respond_to do |format|
      if @user.save
        session[:id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      if @user.can_be_deleted?
        if @user.destroy
          debugger
          format.html { redirect_to users_url }
          format.json { head :no_content }
        else
          format.html { redirect_to current_org, notice: 'There was an error deleting this user'}
          format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to current_org, notice: 'There was an error deleting this user'}
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user || User.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :organization_id)
    end

    def org_params
      params.require(:organization).permit(:name)
    end

    def verify_user
      if current_user.nil? || current_user.to_param != params[:id]
        redirect_with_error("You do not have permission to view that page", request.referer)
      end
    end

end
