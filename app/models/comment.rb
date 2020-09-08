class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  belongs_to :commentable, polymorphic: true
  has_rich_text :body
end
