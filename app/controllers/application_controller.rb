class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :current_user_json
  serialization_scope :current_user

  include ApplicationHelper
  #################
  # Authorization #
  #################
  
  def ensure_user_can_create_resource
    unless current_user && current_user.send(user_resource_create_method, _resource_id)
      redirect_with_error("You do not have permission to create that #{_resource_singular}")
    end
  end

  def ensure_user_can_edit_resource
    unless current_user && current_user.send(user_resource_edit_method, _resource_instance)
      redirect_with_error("You do not have permission to edit that #{_resource_singular}")
    end
  end
  
  def ensure_user_can_view_organization
    unless current_user && current_user.can_view_organization?(_resource_instance)
      redirect_with_error("You do not have permission to view that #{_resource_singular}")
    end
  end
end
