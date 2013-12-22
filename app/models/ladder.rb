class Ladder < ActiveRecord::Base
  has_many :competitors, dependent: :destroy
  has_many :matches, dependent: :destroy

  validates :name, presence: true
end
