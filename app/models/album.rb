class Album < ApplicationRecord
  belongs_to :user
  has_many :users, through: :shares
  has_and_belongs_to_many :photos
  validates :title, presence: true
end
