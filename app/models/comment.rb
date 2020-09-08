class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_rich_text :body

  scope :order_by_old_to_new, -> { order('created_at DESC') }
end
