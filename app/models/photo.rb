require_relative 'gps'

class Photo < ApplicationRecord
  has_one_attached :image, dependent: :purge_later

  def read_image_metadata
    MiniMagick::Image.open(image).exif
  end

  def populate_with(metadata)
    if metadata['GPSLatitude'].nil?
      update(file_name: image.filename,
             latitude_in_degrees: '0',
             longitude_in_degrees: '0',
             date_time_digitized: DateTime.strptime(metadata['DateTime'], '%Y:%m:%d %H:%M:%S'),
             latitude_in_decimal: 0,
             longitude_in_decimal: 0)
    else
      update(file_name: image.filename,
             latitude_in_degrees: "#{metadata['GPSLatitude']}, #{metadata['GPSLatitudeRef']}",
             longitude_in_degrees: "#{metadata['GPSLongitude']}, #{metadata['GPSLongitudeRef']}",
             date_time_digitized: DateTime.strptime(metadata['DateTime'], '%Y:%m:%d %H:%M:%S'))
    end
  end

  def initialize_latlong_decimals
    return unless location?

    coordinates = Coordinates.new(latitude_in_degrees, longitude_in_degrees)
    coordinates = Gps.new.to_decimal(coordinates)
    update(latitude_in_decimal: coordinates.latitude,
           longitude_in_decimal: coordinates.longitude)
  end

  def location?
    return false if latitude_in_degrees == '0' && longitude_in_degrees == '0'

    true
  end
end
