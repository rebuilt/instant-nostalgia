class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :authorized_albums, through: :shares, source: :album

  has_secure_password

  validates :email, :username, uniqueness: true
  validates :email, :password, :username, presence: true
  validates :password, length: { minimum: 8 }

  before_validation :downcase_email

  def downcase_email
    self.email = email.downcase if email.present?
  end

  scope :search, lambda { |term|
                   email_contains(term)
                     .or(username_contains(term))
                     .or(first_name_contains(term))
                     .or(last_name_contains(term))
                 }
  scope :email_contains, ->(term) { where('email LIKE ?', "%#{term}%") }
  scope :username_contains, ->(term) { where('username LIKE ?', "%#{term}%") }
  scope :first_name_contains, ->(term) { where('first_name LIKE ?', "%#{term}%") }
  scope :last_name_contains, ->(term) { where('last_name LIKE ?', "%#{term}%") }
end
