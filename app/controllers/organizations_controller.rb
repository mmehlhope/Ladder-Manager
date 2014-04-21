class OrganizationsController < ApplicationController
  before_action :set_org, except: [:create, :new]

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @ladders_json = @organization.ladders_json
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(org_params)
    if @organization.save
      params = organization_params
      params[:organization_id] = @organization.id
      debugger
      @organization = Organization.new(params)
    end
    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Or was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organization }
      else
        format.html { render action: 'new' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
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
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end

  private

    def set_org
      @organization = current_org || Organization.find_by_id(params[:id])
    end
end
