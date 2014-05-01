class Organization < ActiveRecord::Base
  include OrganizationHelper

  has_many :ladders, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9  ']*\z/, message: "can only contain letters, numbers, and spaces."
  }

  def has_lone_admin?
    users.size == 1
  end
end
