class LaddersController < ApplicationController
  before_action :verify_user, only: [:new, :create, :update, :destroy]
  before_action :set_ladder, only: [:show, :edit, :admin_preferences, :update, :destroy]
  before_action :ensure_user_can_admin_ladder, only: [:edit, :update, :destroy]

  # GET /ladders
  # GET /ladders.json
  def index
    @ladders = current_user.ladders
  end

  # GET /ladders/1
  # GET /ladders/1.json
  def show
    # Sort competitors highest -> lowest rating
    @competitors = @ladder.rating_desc
    # Sort matches newest -> oldest creation date
    @matches = @ladder.matches.order("created_at desc").limit(5)
  end

  # GET /ladders/new
  def new
    @ladder = current_user.ladders.build
  end

  # GET /ladders/1/edit
  def edit
  end

  # POST /ladders
  # POST /ladders.json
  def create
    @ladder = current_user.ladders.build(ladder_params)

    respond_to do |format|
      if @ladder.save
        # send welcome email
        begin
          LadderMailer.welcome_email(@ladder).deliver
        rescue
          flash[:alert] = "Your welcome email failed to send. Please bookmark this page for future reference."
        end
        format.html {
          flash[:success] = "Ladder was successfully created."
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

        if user_is_submitting_preferences?
          successMsg = 'Admin preferences have been successfully updated.'
          # Send password changed notice
          LadderMailer.password_changed(@ladder).deliver
        else
          successMsg = 'Ladder was successfully updated.'
        end

        format.html {
          flash[:success] = successMsg
          redirect_to @ladder
        }
        format.json { head :no_content }
      else
        action = user_is_submitting_preferences? ? 'admin_preferences' : 'edit'
        format.html { render action: action }
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

  # GET /ladders/1/admin_preferences
  def admin_preferences
  end

  private

    def set_ladder
      @ladder = Ladder.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ladder_params
      params.require(:ladder).permit(:name)
    end

    def verify_user
      if current_user.nil?
        redirect_with_error("You must login before you can create a ladder", login_path)
      end
    end

end
