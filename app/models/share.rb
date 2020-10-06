class Share < ApplicationRecord
  belongs_to :user
  belongs_to :album
  belongs_to :photo
end
