class Photo < ApplicationRecord
  has_one_attached :image

  def read_image_metadata
    MiniMagick::Image.open(image).exif
  end

  def populate_with(metadata)
    # update(file_name: image.filename,
    #        latitude: metadata['GPSLatitude'])
    update(address: metadata, file_name: image.filename)
  end
end
