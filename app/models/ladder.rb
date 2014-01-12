class Ladder < ActiveRecord::Base
  belongs_to :user
  has_many :competitors, dependent: :destroy
  has_many :matches, dependent: :destroy

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9  ']*\z/, message: "can only contain letters, numbers, and spaces."
  }

end