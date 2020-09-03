class Album < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :shares, class_name: 'User'
  has_and_belongs_to_many :photos
  validates :title, presence: true
end
