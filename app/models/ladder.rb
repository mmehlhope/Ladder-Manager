class Ladder < ActiveRecord::Base
  include LaddersHelper

  belongs_to :organization

  has_many :competitors, dependent: :destroy
  has_many :matches, dependent: :destroy

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9  ']*\z/, message: "can only contain letters, numbers, and spaces."
  }
  validates :within_match_limits
  validates :within_competitor_limits
  validates_associated :organization, message: "has reached the maximum number of allowed ladders. Email contact@laddermanager.com to request a higher limit."
  
  MATCH_LIMIT = 500
  COMPETITOR_LIMIT = 25

  def within_match_limits
    return if matches.blank?
    errors.add(:base, "You've reached the maximum number of allowed matches.") if matches.size >= MATCH_LIMIT
  end

  def within_competitor_limits
    return if competitors.blank?
    errors.add(:base, "You've reached the maximum number of allowed competitors.") if competitors.size >= COMPETITOR_LIMIT
  end
end
