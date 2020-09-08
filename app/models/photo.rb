require_relative 'gps'
require_relative 'metadata'

class Photo < ApplicationRecord
  has_one_attached :image, dependent: :purge_later
  belongs_to :user
  has_and_belongs_to_many :albums
  has_many :comments, as: :commentable
  # has many users/commenters through comments

  def init
    metadata = read_image_metadata
    populate_with(metadata)
    initialize_latlong_decimals
  end

  scope :include_image, -> { includes(image_attachment: :blob) }
  scope :belonging_to_user, ->(user) { where(user: user) }

  private

  def read_image_metadata
    metadata = MiniMagick::Image.open(image).exif
    Metadata.new(metadata)
  end

  def populate_with(metadata)
    if metadata.has_location?
      update(file_name: image.filename,
             latitude_in_degrees: metadata.latitude,
             longitude_in_degrees: metadata.longitude,
             date_time_digitized: metadata.date_time_digitized)
    else
      update(file_name: image.filename,
             latitude_in_degrees: '0',
             longitude_in_degrees: '0',
             date_time_digitized: metadata.date_time_digitized,
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
end
