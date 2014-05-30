class UserSerializer < ApplicationSerializer
  self.root = false

  def attributes
    hash = super
    hash[:id]                = object.id
    hash[:date_created]      = date_created
    hash[:last_updated]      = updated_how_long_ago
    hash[:last_sign_in]      = object.last_sign_in_at
    hash[:is_activated]      = object.is_activated?
    hash[:name]              = object.name
    hash[:email]             = object.email
    hash[:organization_id]   = object.organization_id
    hash
  end
end
