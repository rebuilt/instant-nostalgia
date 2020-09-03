class User < ApplicationRecord
  has_many :photos
  has_many :albums
  has_many :shares
  has_many :authorized_albums, through: :shares, source: :album

  has_secure_password

  validates :email, :username, uniqueness: true
  validates :email, :password, :username, presence: true

  before_validation :downcase_email

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
