class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_org, except: [:create, :new]
  before_action :ensure_user_can_view_organization, only: [:show]
  before_action :ensure_user_can_edit_resource, only: [:update, :destroy]

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    respond_to do |format|
      format.html {
        @organization_json = @organization.to_json
        @ladders_json = ladders_json
        @users_json   = users_json
      }
      format.json {
        render json: @organization
      }
    end
  end

  # GET /organizations/new
  def new
    # User is already in an organization, no need to create another
    if current_org
      redirect_to current_org
    else
      flash.discard[:notice]
      @organization = Organization.new
      render layout: 'devise'
    end
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(org_params)
    respond_to do |format|
      if @organization.save
        # Assign org to user
        current_user.update_attributes(organization_id: @organization.id)
        # send welcome email
        send_welcome_email(current_user)

        format.html { redirect_to @organization }
        format.json { render json: @organization }
      else
        flash[:error] = @organization.errors.full_messages
        format.html { redirect_to new_organization_path }
        format.json { render json: {errors: @organization.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(org_params)
        format.html { redirect_to @organization }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: {errors: @organization.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to current_user }
      format.json { render json: @organization }
    end
  end

  private

    def org_params
      params.require(:organization).permit(:name)
    end

    def set_org
      begin
        @organization = Organization.find(params[:id])
      rescue
        redirect_with_error("That organization does not exist or you do not have access to it.") 
      end
    end

    def ensure_user_can_edit_organization
      unless current_user && current_user.can_edit_organization?(@organization)
        redirect_with_error("You do not have permission to edit that organization")
      end
    end

    def ladders_json
      ActiveModel::ArraySerializer.new(
        @organization.ladders,
        each_serializer: LadderSerializer,
        scope: serialization_scope
      ).to_json
    end

    def users_json
      sorted_users = @organization.users.sort { |x,y| x.full_name <=> y.full_name }
      ActiveModel::ArraySerializer.new(
        sorted_users,
        each_serializer: UserSerializer,
        scope: serialization_scope
      ).to_json
    end

    def send_welcome_email(user)
      LadderMailer.welcome_email(user).deliver
    end
end
