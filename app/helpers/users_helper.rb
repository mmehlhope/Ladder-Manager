module UsersHelper

  def last_sign_in

  end

  def is_activated?
    !confirmation_token.nil?
  end
end
