class Organization < ActiveRecord::Base
  include OrganizationHelper

  has_many :ladders, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9  -]+\z/, message: "can only contain letters, numbers, spaces, and hyphens."
  }

  def has_lone_admin?
    users.size == 1
  end
end
