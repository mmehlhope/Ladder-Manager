class LaddersController < ApplicationController
  before_action :verify_user, only: [:new, :create, :update, :destroy]
  before_action :set_ladder, only: [:show, :edit, :update, :destroy]
  before_action :search, only: [:index]
  before_action :ensure_user_can_admin_ladder, only: [:edit, :update, :destroy]

  # GET /ladders
  # GET /ladders.json
  def index
    respond_to do |format|
      format.html {}
      format.json {
        render json: @ladders, root: false
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
    @matches_json     = @ladder.editable_matches_json
    @competitors_json = @ladder.competitors_json
    @ladder_json      = @ladder.to_json
  end

  # POST /ladders
  # POST /ladders.json
  def create
    @ladder = current_org.ladders.build(ladder_params)

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

    def search
      query = params[:query].strip! || params[:query]

      if query =~ /\A[0-9]+\z/
        @ladders = Ladder.where("id = :query", query: query)
      elsif query =~ /\A[\w ]+\z/
        @ladders = Ladder.where("name LIKE :query", query: "%#{query}%")
      else
        @ladders = []
      end
    end

    def set_ladder
      begin
        @ladder = Ladder.find(params[:id])
      rescue
        redirect_with_error('That ladder no longer exists', (current_user_and_org? ? organization_path(current_org) : root_path))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ladder_params
      params.require(:ladder).permit(:name)
    end

    def verify_user
      if current_user.nil?
        redirect_with_error("You must be logged in to modify a ladder", new_user_session_path)
      end
    end

end