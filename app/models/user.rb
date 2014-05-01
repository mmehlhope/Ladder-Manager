class User < ActiveRecord::Base
  belongs_to :organization

  before_validation :downcase_email
  has_secure_password

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9' ]*\z/, message: "can only contain letters, numbers, and spaces."
  }
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "must be a valid email address."
  }

  def can_delete_user?(user_id)
    if id == user_id.to_i
      errors.add(:base, "You cannot delete yourself")
      return false
    else
      return true
    end
  end

  private

    def downcase_email
      self.email = self.email.downcase if self.email.present?
    end

end