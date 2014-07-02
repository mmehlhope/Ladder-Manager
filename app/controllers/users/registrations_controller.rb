class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create]

  def create
    super
    send_welcome_email(@user) unless @user.invalid?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def after_sign_up_path_for(resource)
    new_organization_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_organization_path
  end

  def send_welcome_email(user)
    LadderMailer.welcome_email(user).deliver
  end
end
