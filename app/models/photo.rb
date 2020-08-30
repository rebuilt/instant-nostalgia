require_relative 'gps'

class Photo < ApplicationRecord
  has_one_attached :image, dependent: :purge_later
  belongs_to :user

  def read_image_metadata
    MiniMagick::Image.open(image).exif
  end

  def populate_with(metadata)
    if has_location_data?(metadata)
      update(file_name: image.filename,
             latitude_in_degrees: "#{metadata['GPSLatitude']}, #{metadata['GPSLatitudeRef']}",
             longitude_in_degrees: "#{metadata['GPSLongitude']}, #{metadata['GPSLongitudeRef']}",
             date_time_digitized: DateTime.strptime(metadata['DateTime'], '%Y:%m:%d %H:%M:%S'))
    else
      update(file_name: image.filename,
             latitude_in_degrees: '0',
             longitude_in_degrees: '0',
             date_time_digitized: DateTime.strptime(metadata['DateTime'], '%Y:%m:%d %H:%M:%S'),
             latitude_in_decimal: 0,
             longitude_in_decimal: 0)
    end
  end

  def initialize_latlong_decimals
    return unless location?

    coordinates = Coordinates.new(latitude_in_degrees, longitude_in_degrees)
    coordinates = Gps.to_decimal(coordinates)
    update(latitude_in_decimal: coordinates.latitude,
           longitude_in_decimal: coordinates.longitude)
  end

  def location?
    return false if latitude_in_degrees == '0' && longitude_in_degrees == '0'

    true
  end

  private

  def has_location_data?(metadata)
    metadata['GPSLatitude'].present?
  end
end
