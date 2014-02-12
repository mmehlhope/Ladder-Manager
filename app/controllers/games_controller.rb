class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :set_match
  before_action :set_ladder
  # before_action :ensure_user_can_admin_ladder, except: [:index, :show]


  # GET /games
  # GET /games.json
  def index
    @games = @match.games
    respond_to do |format|
      format.html
      format.json {
        render json: @games, root: false
      }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    respond_to do |format|
      format.html
      format.json {
        render json: @game, root: false
      }
    end
  end

  # GET /games/new
  def new
    if @match.finalized?
      error_msg = 'Games cannot be added to a finalized match.'
      respond_to do |format|
        format.html {
          flash[:error] = error_msg
          redirect_to @match
        }
        format.json { render json: {msg: error_msg } }
      end
    else
      @game = Game.new
    end
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = @match.games.build(game_params)
    respond_to do |format|
      if @game.save
        format.html {
          flash[:success] = 'Game was successfully added.'
          redirect_to @match
        }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html {
          flash[:success] = 'Game was successfully updated.'
          redirect_to edit_ladder_path(@match.ladder)
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy

    respond_to do |format|
      if @game.destroy
        format.html { redirect_to match_path(@match) }
        format.json { head :no_content }
      else
        format.html {
          flash[:error] = "There was an error deleting the selected game"
          redirect_to match_path(@match)
        }
        format.json {
          render json: @game.errors, status: :unprocessable_entity
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find_by_id(params[:id])
    end

    def set_match
      id = params[:match_id] || @game.match_id
      @match = Match.find_by_id(id)
    end

    def set_ladder
      @ladder = @match.ladder
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:competitor_1_score, :competitor_2_score, :winner_name, :winner_id)
    end
end
