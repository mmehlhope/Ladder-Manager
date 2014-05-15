class OrganizationsController < ApplicationController
  before_action :set_org, except: [:create, :new]
  before_action :authenticate_user!

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @ladders_json = @organization.ladders_json
    @users_json   = @organization.users_json
  end

  # GET /organizations/new
  def new
    # User is already in an organization, no need to create another
    if current_org
      redirect_to current_org
    else
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

        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization }
      else
        format.html { render action: 'new' }
        format.json { render json: {errors: @organization.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(org_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
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
      @organization = current_org || Organization.find_by_id(params[:id])
    end
end
