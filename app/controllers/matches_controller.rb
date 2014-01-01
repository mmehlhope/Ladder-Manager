class MatchesController < ApplicationController
  before_action :set_match, except: [:index, :new]
  before_action :set_ladder
  before_action :get_all_ladder_competitors, only: [:new, :create, :edit]
  before_action :ensure_user_can_admin_ladder, except: [:index, :show]


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
    @competitors_hash = @competitors.inject({}) {|h, comp| h.merge({comp.name => comp.id})}
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    if match_params[:competitor_1].blank? || match_params[:competitor_2].blank?
      flash[:error] = "Two competitors must be selected to create a match."
      redirect_to new_ladder_match_path(@ladder)
    else
      @match = @ladder.matches.build(match_params)

      # Find competitors and add them to the match association
      competitors = Competitor.find([match_params[:competitor_1], match_params[:competitor_2]])
      @match.competitors << competitors

      respond_to do |format|
        if @match.save
          format.html {
            flash[:success] = 'Match was successfully created.'
            redirect_to match_path(@match)
          }
          format.json { render action: 'show', status: :created, location: @match }
        else
          format.html { render action: 'new' }
          format.json { render json: @match.errors, status: :unprocessable_entity }
        end
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
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /matches/1/finalize
  def finalize

    # Validate
    errors = "Match was already finalized" if @match.finalized?
    errors = "Match must contain at least one game to be finalized" if @match.games.count == 0
    errors = "Match cannot result in a tie. Please record additional games or adjust the current games.
    to where there is a decisive victor." if @match.determine_match_winner.nil?

    if errors.blank?
      @match.finalize
    end

    respond_to do |format|
      if @match.finalized?

        @match.update_player_stats

        format.html {
          flash[:success] = 'Match has been finalized. No further changes can be made to this match.'
          redirect_to match_path(@match)
        }
        format.json { head :ok }
      else
        errors = "There was an error finalizing the match" if errors.blank?
        format.html {
          flash[:error] = errors
          redirect_to match_path(@match)
        }
        format.json { render json: { :msg => errors} }
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
      params[:match].permit(:competitor_1, :competitor_2)
    end
end
