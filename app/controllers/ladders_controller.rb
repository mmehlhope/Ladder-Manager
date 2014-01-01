class LaddersController < ApplicationController
  before_action :set_ladder, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user_can_admin_ladder, only: [:edit, :update, :destroy]

  # GET /ladders
  # GET /ladders.json
  def index
    @ladders = Ladder.all
  end

  # GET /ladders/1
  # GET /ladders/1.json
  def show
    # Sort competitors highest -> lowest rating
    @competitors = @ladder.competitors.sort { |a,b| b.rating <=> a.rating }
    # Sort matches newest -> oldest creation date
    @matches = @ladder.matches.limit(5).sort { |a,b| b.created_at <=> a.created_at }
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

        # set session admin
        session[:user_can_admin] = [@ladder.id]

        format.html {
          flash[:success] = 'Ladder was successfully created.'
          redirect_to @ladder
        }
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
        format.html {
          flash[:success] = 'Ladder was successfully updated.'
          redirect_to @ladder
        }
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
        format.html { redirect_to root_path }
        format.json { head :no_content }
      else
        format.html {
          flash[:error] = 'There was an error deleting this ladder. Please try again later.'
          redirect_to @ladder
        }
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

    unless ladder.nil? or error
      redirect_to ladder
    else
      error ||= "That Ladder ID was not found, please try again."
      flash[:error] = error
      redirect_to root_path
    end
  end

  private
    def set_ladder
      @ladder = Ladder.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ladder_params
      params.require(:ladder).permit(:name, :admin_email, :password_digest, :password, :password_confirmation)
    end
end
