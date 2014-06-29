class CompetitorsController < ApplicationController
  before_action :set_competitor, only: [:show, :edit, :update, :destroy]
  before_action :set_ladder
  before_action :ensure_user_can_create_resource, only: [:create]
  before_action :ensure_user_can_edit_resource, only: [:edit, :update, :destroy]
  # GET /competitors
  # GET /competitors.json
  def index
    @competitors = @ladder.competitors
    render json: @competitors, root: false
  end

  # GET /competitors/1
  # GET /competitors/1.json
  def show
    render json: @competitor, root: false
  end

  # GET /competitors/new
  def new
    @competitor = @ladder.competitors.build
  end

  # GET /competitors/1/edit
  def edit
  end

  # POST /competitors
  # POST /competitors.json
  def create
    @competitor = @ladder.competitors.build(competitor_params)
    success_msg = @competitor.name + " was successfully added to the ladder"
    respond_to do |format|
      if @competitor.save
        format.html {
          flash[:success] = success_msg
          redirect_to @ladder
        }
        format.json { render json: @competitor, status: :created}
      else
        format.html { render action: 'new' }
        format.json { render json: {errors: @competitor.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitors/1
  # PATCH/PUT /competitors/1.json
  def update
    respond_to do |format|
      if @competitor.update(competitor_params)
        format.html {
          flash[:success] = "#{@competitor.name} was successfully updated."
          redirect_to ladder_path(@ladder)
        }
        format.json { render json: @competitor }
      else
        format.html { render action: 'edit' }
        format.json { render json: {errors: @competitor.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitors/1
  # DELETE /competitors/1.json
  def destroy
    respond_to do |format|
      if @competitor.destroy
        format.html {
          flash[:success] = "Competitor has been successfully deleted"
          redirect_to ladder_path(@ladder)
        }
        format.json { render json: @competitor, status: :ok }
      else
        format.html {
          flash[:error] = "There was an error deleting the selected competitor"
          redirect_to ladder_path(@ladder)
        }
        format.json {
          render json: {errors: @competitor.errors.full_messages}, status: :unprocessable_entity
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competitor
      @competitor = Competitor.find(params[:id])
    end

    def set_ladder
      id = params[:ladder_id] ||= @competitor.ladder_id
      @ladder = Ladder.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competitor_params
      params.require(:competitor).permit(:name)
    end
end
