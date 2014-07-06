class SignupsController < ApplicationController

  def create
    respond_to do |format|
      signup = Signup.new(signup_params)
      if signup.save
        format.html {
          flash[:success] = "Email received! We'll be in touch soon with account details."
          redirect_to root_path
        }
        format.json { render json: {status: "Email received! We'll be in touch soon with account details."}, status: :ok }
      else
        format.html {
          errors = signup.errors.present? ? signup.errors.full_messages : "There was an error with your signup. Please try again later."
          flash[:error] = errors 
          redirect_to root_path
        }
        format.json { render json: {errors: errors}, status: :ok }
      end
    end
  end

  protected

  def signup_params
    params.require(:signup).permit(:email)
  end
end
