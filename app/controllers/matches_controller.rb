class MatchesController < ApplicationController
  before_action :set_match, except: [:index, :new]
  before_action :set_ladder
  before_action :get_all_ladder_competitors, only: [:new]
  before_action :ensure_user_can_create_resource, only: [:create]
  before_action :ensure_user_can_edit_resource, only: [:edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = @ladder.matches.order("updated_at desc")
    render json: @matches, root: false
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    render json: @match, root: false
  end

  # GET /matches/new
  def new
    @match = @ladder.matches.build
    @competitors_hash = @competitors.inject({}) {|h, comp| h.merge({comp.name => comp.id})}
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = @ladder.matches.build(match_params)

    respond_to do |format|
      if @match.save
        # Find competitors and add them to the match association
        competitors = Competitor.find([match_params[:competitor_1], match_params[:competitor_2]])
        @match.competitors << competitors
        format.html {
          flash[:success] = 'Match was successfully created.'
          redirect_to match_path(@match)
        }
        format.json { render json: @match, status: :created }
      else
        format.html { redirect_to edit_ladder_path(@match.ladder) }
        format.json { render json: {errors: @match.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html {
          flash[:success] = 'Match was successfully updated.'
          redirect_to match_path(@match)
        }
        format.json { head :ok }
      else
        format.html { redirect_to edit_ladder_path(@match.ladder) }
        format.json { render json: {errors: @match.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # POST /matches/1/finalize
  def finalize

    respond_to do |format|
      if @match.finalize

        @match.update_player_stats

        format.html {
          flash[:success] = 'Match has been finalized. No further changes can be made to this match.'
          redirect_to match_path(@match)
        }
        format.json { render json: @match, status: :ok }
      else
        format.html {
          flash[:error] = @match.errors.full_messages
          redirect_to match_path(@match)
        }
        format.json { render json: {errors: @match.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html {
        flash[:success] = "Match has been successfully deleted."
        redirect_to ladder_matches_path(@ladder)
      }
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
      params[:match].permit(:competitor_1, :competitor_2, :finalized)
    end
end
