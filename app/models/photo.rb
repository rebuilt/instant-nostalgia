class Photo < ApplicationRecord
  has_one_attached :image

  def read_image_metadata
    # TODO: implement
  end

  def populate_with
    # TODO: implement
  end
end
