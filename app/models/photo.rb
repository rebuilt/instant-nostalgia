require 'time'

class Photo < ApplicationRecord
  has_one_attached :image

  def read_image_metadata
    MiniMagick::Image.open(image).exif
  end

  def populate_with(metadata)
    # update(file_name: image.filename,
    #        latitude: metadata['GPSLatitude'])
    update(file_name: image.filename,
           latitude_in_degrees: "#{metadata['GPSLatitude']}, #{metadata['GPSLatitudeRef']}",
           longitude_in_degrees: "#{metadata['GPSLongitude']}, #{metadata['GPSLongitudeRef']}",
           date_time_digitized: DateTime.strptime(metadata['DateTime'], '%Y:%m:%d %H:%M:%S'))
    # "2019:07:31 12:57:57"
  end
end
