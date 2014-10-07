class LaddersController < ApplicationController
  before_action :set_organization
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :set_ladder, only: [:show, :edit, :update, :destroy]
  before_action :set_ladders, only: [:index]
  before_action :ensure_user_can_create_resource, only: [:create]
  before_action :ensure_user_can_edit_resource, only: [:edit, :update, :destroy]
  before_action :set_cache_buster, only: [:edit]

  # GET /ladders
  # GET /ladders.json
  def index
    respond_to do |format|
      format.html {
        @organization_json = current_org.to_json
        @ladders_json      = ladders_json
      }
      format.json {
        render json: @ladders_json, root: false
      }
    end
  end

  # GET /ladders/1
  # GET /ladders/1.json
  def show
    # Sort competitors highest -> lowest rating
    @competitors = @ladder.rating_desc
    # Sort matches newest -> oldest creation date
    @matches = @ladder.matches.order("updated_at desc").limit(5)

    respond_to do |format|
      format.html
      format.json {
        render json: @ladder, expanded: true
      }
    end
  end

  # GET /ladders/new
  def new
    @ladder = current_org.ladders.build
  end

  # GET /ladders/1/edit
  def edit
    @matches_json     = editable_matches_json
    @competitors_json = competitors_json
    @ladder_json      = LadderSerializer.new(@ladder).to_json
  end

  # POST /ladders
  # POST /ladders.json
  def create
    @ladder = @organization.ladders.build(ladder_params)

    respond_to do |format|
      if @ladder.save
        format.html {
          flash[:success] = "Ladder was successfully created."
          redirect_to edit_ladder_path(@ladder)
        }
        format.json { render json: @ladder }
      else
        format.html { render action: 'new' }
        format.json { render json: {errors: @ladder.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ladders/1
  # PATCH/PUT /ladders/1.json
  def update
    respond_to do |format|
      if @ladder.update(ladder_params)
        successMsg = 'Ladder was successfully updated.'

        format.html {
          flash[:success] = successMsg
          redirect_to edit_ladder_path(@ladder)
        }
        format.json { render json: @ladder}
      else
        format.html { render action: 'edit' }
        format.json { render json: {errors: @ladder.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ladders/1
  # DELETE /ladders/1.json
  def destroy
    respond_to do |format|
      if @ladder.destroy
        format.html { redirect_to organization_path(current_org) }
        format.json { render json: @ladder, status: :ok }
      else
        format.html {
          flash[:error] = 'There was an error deleting this ladder. Please try again later.'
          redirect_to @ladder
        }
        format.json { render json: {errors: @ladder.errors.full_messages},  status: :unprocessable_entity}
      end
    end
  end


  private

    def set_ladders
      @ladders = current_org ? current_org.ladders : []
    end

    def set_ladder
      begin
        @ladder = Ladder.find(params[:id])
      rescue
        redirect_with_error('That ladder no longer exists', (current_user_and_org? ? organization_path(current_org) : root_path))
      end
    end

    def set_organization
      @organization = Organization.find_by_id(params[:organization_id]) || current_org
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ladder_params
      params.require(:ladder).permit(:name, :organization_id)
    end

    def all_matches_json
      ActiveModel::ArraySerializer.new(
        @ladder.all_matches,
        each_serializer: MatchSerializer,
        scope: serialization_scope
      ).to_json
    end

    def editable_matches_json
      ActiveModel::ArraySerializer.new(
        @ladder.editable_matches,
        each_serializer: MatchSerializer,
        scope: serialization_scope
      ).to_json
    end

    def competitors_json
      ActiveModel::ArraySerializer.new(
        @ladder.competitors,
        each_serializer: CompetitorSerializer,
        scope: serialization_scope
      ).to_json
    end

    def ladders_json
      ActiveModel::ArraySerializer.new(
        @organization.ladders,
        each_serializer: LadderSerializer,
        scope: serialization_scope
      ).to_json
    end
end
