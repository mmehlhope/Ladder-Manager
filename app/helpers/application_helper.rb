module ApplicationHelper

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  ################
  # User helpers #
  ################

  def current_user_json
    if devise_current_user
      @current_user_json ||= UserSerializer.new(current_user).to_json
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

  def resource_association_map
    resource_association_map = {
      users: "organization",
      ladders: "organization",
      matches: "ladder",
      competitors: "ladder",
      games: "match",
    } 
    resource_association_map
  end

  def _resource_association
    resource_association_map[_resource.to_sym]
  end

  def user_resource_create_method
    "can_create_#{_resource_singular}_in_#{_resource_association}?"
  end

  def user_resource_edit_method
    "can_edit_#{_resource_singular}?"
  end

  def _resource_instance
    instance_variable_get("@#{_resource_singular}") 
  end

  def _resource_id
    params["#{_resource_association}_id".to_sym].to_i
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
        if current_user_and_org?
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
    if devise_controller? 
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
