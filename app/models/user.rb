class User < ApplicationRecord
  has_many :photos

  has_secure_password

  validates :email, uniqueness: true
  validates :username, uniqueness: true
end
