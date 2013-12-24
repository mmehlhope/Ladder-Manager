class LaddersController < ApplicationController
  before_action :set_ladder, only: [:show, :edit, :update, :destroy]

  # GET /ladders
  # GET /ladders.json
  def index
    @ladders = Ladder.all
  end

  # GET /ladders/1
  # GET /ladders/1.json
  def show
    # Sort competitors in descending order by rating
    @competitors = @ladder.competitors.sort { |a,b| b.rating <=> a.rating }
    @matches = @ladder.matches.limit(5)
  end

  # GET /ladders/new
  def new
    @ladder = Ladder.new
  end

  # GET /ladders/1/edit
  def edit
  end

  # POST /ladders
  # POST /ladders.json
  def create
    @ladder = Ladder.new(ladder_params)

    respond_to do |format|
      if @ladder.save
        format.html { redirect_to @ladder, notice: 'Ladder was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ladder }
      else
        format.html { render action: 'new' }
        format.json { render json: @ladder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ladders/1
  # PATCH/PUT /ladders/1.json
  def update
    respond_to do |format|
      if @ladder.update(ladder_params)
        format.html { redirect_to @ladder, notice: 'Ladder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ladder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ladders/1
  # DELETE /ladders/1.json
  def destroy
    respond_to do |format|
      if @ladder.destroy
        format.html { redirect_to ladders_path }
        format.json { head :no_content }
      else
        format.html { redirect_to @ladder, alert: "There was an error deleting this ladder"}
        format.json { render json: @ladder.errors,  status: :unprocessable_entity}
      end
    end
  end

  # GET /ladders/search
  def search
    if params[:id] =~ /\A[0-9]+\z/
      ladder = Ladder.find_by_id(params[:id])
    else
      error = "Ladder IDs can only be numbers, please try again."
    end

    unless ladder.nil? or @error
      redirect_to ladder
    else
      error ||= "That Ladder ID was not found, please try again."
      redirect_to root_path, alert: error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ladder
      @ladder = Ladder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ladder_params
      params.require(:ladder).permit(:name, :admin_email)
    end
end
