class Album < ApplicationRecord
  belongs_to :user
  has_many :shares, dependent: :destroy
  has_many :users, through: :shares
  has_and_belongs_to_many :photos
  validates :title, presence: true

  scope :include_images, -> { includes(photos: [image_attachment: :blob]) }
end
