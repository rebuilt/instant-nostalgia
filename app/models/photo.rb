require_relative 'gps'
require_relative 'metadata'

class Photo < ApplicationRecord
  has_one_attached :image, dependent: :purge_later
  belongs_to :user
  has_and_belongs_to_many :albums
  has_many :comments, as: :commentable
  has_many :shares, dependent: :destroy
  has_many :authorized_users, through: :shares, source: :user, dependent: :destroy
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..25.megabytes }

  geocoded_by :address
  reverse_geocoded_by :latitude_in_decimal, :longitude_in_decimal do |obj, results|
    if geo = results.first
      obj.suburb = geo.suburb
      obj.village = geo.village
      obj.city = geo.city
      obj.state = geo.state
      obj.state_code = geo.state_code
      obj.postal_code = geo.postal_code
      obj.country = geo.country
      obj.country_code = geo.country_code
      obj.raw_address = geo.display_name
    end
  end

  def init
    metadata = read_image_metadata
    populate_with(metadata)
    initialize_latlong_decimals
    save && location?
  end

  def init_address
    reverse_geocode
    save && location?
  end

  scope :include_image, -> { includes(image_attachment: :blob) }
  scope :belonging_to_user, ->(user) { where(user: user) }
  scope :most_recent, ->(count) { order(created_at: :desc).limit(count) }
  scope :most_recent_mappable, ->(count) { all.order(created_at: :desc).reject { |photo| photo.location? == false }.first(count) }
  scope :order_by_new_to_old, -> { order(created_at: :desc) }
  scope :day_is, lambda { |day|
                   where('EXTRACT(DAY FROM date_time_digitized) = ?', day)
                 }
  scope :month_is, lambda { |month|
                     where('EXTRACT(MONTH FROM date_time_digitized) = ?', month)
                   }
  scope :date_between, lambda { |start_date, end_date|
    where(date_time_digitized: start_date..(end_date + 1.day))
  }

  def location?
    if (latitude_in_decimal.nil? || latitude_in_decimal == 0.0) && (longitude_in_decimal.nil? || longitude_in_decimal == 0.0)
      return false
    end

    true
  end

  private

  def read_image_metadata
    metadata = MiniMagick::Image.open(image).exif
    output = Metadata.new(metadata) unless metadata.nil?
    output
  end

  def populate_with(metadata)
    return if metadata.nil?

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
    coordinates = Coordinates.new(latitude_in_degrees, longitude_in_degrees)
    coordinates = Gps.to_decimal(coordinates)
    update(latitude_in_decimal: coordinates.latitude,
           longitude_in_decimal: coordinates.longitude)
  end
end
