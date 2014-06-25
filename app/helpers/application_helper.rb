module ApplicationHelper

  ################
  # User helpers #
  ################
  def current_user_json
    if current_user
      @current_user_json = UserSerializer.new(current_user).to_json
    else
      nil
    end
  end

  def current_org
    @current_organization ? @current_organization : (current_user ? current_user.organization : false)
  end

  def current_user_and_org?
    current_user && current_org
  end

  #################
  # Authorization #
  #################
  
  #
  # TODO: MAKE THIS BULLETPROOF BY PASSING IN ASSOCIATIVE IDS 
  #
  def ensure_user_can_create_resource
    unless user_can_create_resource
      redirect_with_error("You do not have permission to edit that #{_resource_singular}")
    end
  end

  def ensure_user_can_edit_resource
    unless user_can_edit_resource
      redirect_with_error("You do not have permission to edit that #{_resource_singular}")
    end
  end
  
  def ensure_user_can_view_organization
    unless user_can_view_organization
      redirect_with_error("You do not have permission to view that #{_resource_singular}")
    end
  end

  def user_can_edit_resource
    return false unless current_org.present?
    
    if _resource == "ladders"
      ladder_id = params[:id]
      current_org.send(_resource).find_by_id(ladder_id).present?
    else
      ladder_id = _resource_instance.try(:ladder_id)
      current_org.ladders.find_by_id(ladder_id).present?
    end
  end

  def user_can_create_resource
    debugger
    whitelisted_resources = %w(organization users ladders matches competitors games)
    ladder_resources = %w(matches competitors)

    # If there is no current org, cannot create anything
   return false unless current_org.present? && whitelisted_resources.include?(_resource) 

    # If it is a ladder resource, see if that ladder exists within the current org
    if ladder_resources.include?(_resource)
      ladder_id = params[:ladder_id]
      current_org.ladders.find_by_id(ladder_id).present?
    # if it's a game, ensure the game's match is within the current org's ladder
    elsif _resource == "games"
      ladder_id = instance_variable_get("@match").try(:ladder_id)
      current_org.ladders.find_by_id(ladder_id).present?
    elsif _resource == "ladders"
      true
    end
  end

  def user_can_view_organization
    current_org.present? && current_org.id == params[:id].to_i
  end
  #########################
  # Authorization Helpers #
  #########################
  
  
  def _resource
    params[:controller]
  end

  def _resource_singular
    _resource.singularize
  end

  def _resource_instance
    instance_variable_get("@" + _resource_singular)
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

  def redirect_with_error(error, path=new_user_session_path)
    error ||= "You do not have permission to complete that action."
    
    respond_to do |format|
      format.html {
        flash[:error] = error
        if current_org.present?
          redirect_to organization_path(current_org)
        else
          redirect_to path
        end
      }
      format.json {
        render json: {errors: error}, status: :unauthorized
      }
    end
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
