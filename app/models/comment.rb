class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  has_rich_text :body
end
