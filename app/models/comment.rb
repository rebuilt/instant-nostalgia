class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_rich_text :body
  # rich text surrounds body string in a div that adds 17 characters.  1017 allows us to set a front-end limit less than or equal to 1000 characters. Limiting rich text so that no one can insert a book as a comment.
  validates :body, length: { maximum: 1017 }

  scope :order_by_old_to_new, -> { order('created_at DESC') }
end
