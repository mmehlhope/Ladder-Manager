class User < ActiveRecord::Base
  has_many :ladders
  has_secure_password

  validates :name, presence: true, format: {
    with: /\A[a-zA-Z0-9]*[a-zA-Z][a-zA-Z0-9']*\z/, message: "can only contain letters and numbers."
  }
  validates :email, presence: true, format: {
    with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "must be a valid email address."
  }
end