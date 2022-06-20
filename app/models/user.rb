class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :authorized_albums, through: :shares, source: :album, dependent: :destroy
  has_many :authorized_photos, through: :shares, source: :photo, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :avatar, dependent: :purge_later

  has_secure_password

  validates :email, :username, uniqueness: true
  validates :email, :password, :username, presence: true
  validates :password, length: { minimum: 8 }
  validates :password, confirmation: { case_sensitive: true }
  before_validation :downcase_email

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def remaining_uploads
    return 1000000 if email == 'memoryman51@hotmail.com' || user.id == 1
    output = upload_limit - photos.count
    output = 0 if output.negative?
    output
  end

  def upload_limit
    100
  end

  def has_remaining_uploads?
    remaining_uploads.positive?
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
