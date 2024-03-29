class UserSerializer < ApplicationSerializer
  self.root = false

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:last_sign_in]      = object.signed_in_how_long_ago
    hash[:is_activated]      = object.is_activated?
    hash[:name]              = object.name
    hash[:email]             = object.email
    hash[:organization_id]   = object.organization_id
    hash[:can_edit] = scope ? scope.can_edit_user?(object) : false
    hash[:can_delete] = scope ? scope.can_delete_user?(object) : false
    hash
  end
end
