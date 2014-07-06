class User < ActiveRecord::Base
  include UsersHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  belongs_to :organization
  validates_associated :organization, message: "has reached the maximum number of allowed users. Email contact@laddermanager.com to request a higher limit."
end
