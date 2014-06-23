module ApplicationHelper

  ################
  # User helpers #
  ################
  def current_user_json
    @current_user_json = UserSerializer.new(current_user).to_json if current_user
  end

  def current_org
    @current_organization ? @current_organization : (current_user ? current_user.organization : false)
  end

  def current_user_and_org?
    current_user && current_org
  end

  def ensure_user_can_admin_ladder
    unless user_can_admin_ladder
      flash[:error] = "Please login to edit the ladder."
      redirect_to new_user_session_path
    end
  end
  
  def ensure_user_can_create_resource
    resource = params[:controller].singularize
    unless user_can_create_resource
      flash[:error] = "You do not have permission to create that #{resource}"
      redirect_to request.referer
    end
  end

  def ensure_user_can_edit_resource
    resource = params[:controller].singularize
    unless user_can_edit_resource
      respond_to do |format|
        message = "You do not have permission to edit that #{resource}"
        format.html {
          flash[:error] = message
          redirect_to request.referer
        }
        format.json {
          render json: {errors: message}, status: :unauthorized
        }
      end
    end
  end
  
  def user_can_edit_resource
    resource = params[:controller] 
    resource_singular = resource.singularize
    id = params[:id] || params[(resource_singular+"_id").to_sym]
    if current_user.nil?
      false
    elsif resource == "ladders"
      current_org.resource.find_by_id(id).present? ? true : false
    else
      ladder_id = instance_variable_get("@"+resource_singular).try(:ladder_id)
      current_org.ladders.find_by_id(ladder_id).present? ? true : false
    end
  end

  ####################
  # Redirect Helpers #
  ####################

  def after_sign_in_path_for(user)
    if current_org
      organization_path(user.organization)
    else
      new_organization_path
    end
  end

  def redirect_with_error(error, path)
    error ||= "You do not have permission to view that page"
    path  ||= root_path
    flash[:error] = error
    redirect_to path
  end

  ##################
  # Global Helpers #
  ##################
  def flash_message?
    true if flash[:notice] || flash[:alert] || flash[:error] || flash[:success]
  end

  def resource
    if params[:controller] == 'devise'
      resource
    else
      resource = instance_variable_get('@' + params[:controller].singularize)
    end
  end

  def resource_error_messages
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-dismissable text-left alert-danger">
      <button class="close" type="button" data-dismiss="alert">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
