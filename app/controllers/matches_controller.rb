class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy, :finalize]
  before_action :set_ladder
  before_action :get_all_ladder_competitors, only: [:new, :create, :edit]

  # GET /matches
  # GET /matches.json
  def index
    @matches = @ladder.matches.sort { |a,b| b.created_at <=> a.created_at }
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = @ladder.matches.build
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = @ladder.matches.build(match_params)

    # Find competitors and add them to the match association
    competitors = Competitor.find([match_params[:competitor_1], match_params[:competitor_2]])
    @match.competitors << competitors

    respond_to do |format|
      if @match.save
        format.html { redirect_to ladder_matches_path(@ladder), notice: 'Match was successfully created.' }
        format.json { render action: 'show', status: :created, location: @match }
      else
        format.html { render action: 'new' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_path(@match), notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /matches/1/finalize
  def finalize

    # Validate
    errors = "Match was already finalized" if @match.finalized?
    errors = "Match must contain at least one game to be finalized" if @match.games.count == 0

    if errors.blank?
      @match.finalize
    end

    respond_to do |format|
      if @match.finalized?

        @match.update_player_stats

        format.html { redirect_to match_path(@match), notice: 'Match was successfully finalized.' }
        format.json { head :ok }
      else
        errors = "There was an error finalizing the match" if errors.blank?
        format.html { redirect_to match_path(@match), notice: errors }
        format.json { render json: { :msg => errors} }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to ladder_matches_path(@ladder) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      id = params[:id] || params[:match_id]
      @match = Match.find_by_id(id)
    end

    def set_ladder
      id = params[:ladder_id] ||= @match.ladder_id
      @ladder = Ladder.find_by_id(id)
    end

    def get_all_ladder_competitors
      @competitors = @ladder.competitors
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params[:match].permit(:competitor_1, :competitor_2)
    end
end
