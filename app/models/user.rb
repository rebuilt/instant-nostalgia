class User < ApplicationRecord
  has_many :photos

  has_secure_password

  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :email, :password, presence: true

  before_validation :downcase_email

  def downcase_email
    self.email = email.downcase
  end
end
