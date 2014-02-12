class CompetitorsController < ApplicationController
  before_action :set_competitor, only: [:show, :edit, :update, :destroy]
  before_action :set_ladder

  # GET /competitors
  # GET /competitors.json
  def index
    @competitors = @ladder.competitors
    respond_to do |format|
      format.json {
        render json: @competitors, root: false
      }
    end
  end

  # GET /competitors/1
  # GET /competitors/1.json
  def show
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
        format.json { render action: 'show', status: :created, location: @ladder }
      else
        format.html { render action: 'new' }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
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
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitors/1
  # DELETE /competitors/1.json
  def destroy
    @competitor.destroy

    respond_to do |format|
      format.html { redirect_to ladder_path(@ladder) }
      format.json { head :ok }
      format.js   { head :ok }
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
