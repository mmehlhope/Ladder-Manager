class User < ActiveRecord::Base
  include UsersHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  belongs_to :organization

  def can_delete_user?(user_id)
    if id == user_id.to_i
      errors.add(:base, "You cannot delete yourself")
      return false
    else
      return true
    end
  end

end