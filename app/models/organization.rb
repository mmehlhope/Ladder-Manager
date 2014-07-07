class Organization < ActiveRecord::Base
  include OrganizationHelper

  has_many :ladders, dependent: :destroy, validate: false
  has_many :users, dependent: :destroy, validate: false

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9  -]+\z/, message: "can only contain letters, numbers, spaces, and hyphens."
  }
  validate :within_ladder_limits
  validate :within_user_limits

  LADDER_LIMIT = 6
  USER_LIMIT = 6
  
  def within_ladder_limits
    return if ladders.blank?
    errors.add(:base, "You've reached the maximum number of allowed ladders.") if ladders.size >= LADDER_LIMIT
  end

  def within_user_limits
    errors.add(:base, "You've reached the maximum number of allowed users.") if users.size >= USER_LIMIT
  end

  def has_lone_admin?
    users.size == 1
  end

end
