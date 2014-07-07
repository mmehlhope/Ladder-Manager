class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create]
  layout "application", only: [:edit]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      render action: 'edit', layout: 'application'
    end
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

  def after_update_path_for(resource)
    organization_path(current_org)
  end
end
