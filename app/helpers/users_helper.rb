module UsersHelper
  include ActionView::Helpers::DateHelper


  def signed_in_how_long_ago
    if last_sign_in_at
      "#{distance_of_time_in_words(Time.now, last_sign_in_at).capitalize} ago"
    else
      "never"
    end
  end

  def is_activated?
    !confirmation_token.nil?
  end

  def all_users
    ActiveModel::ArraySerializer.new(
      User.all,
      each_serializer: UserSerializer,
    ).to_json
  end
end
