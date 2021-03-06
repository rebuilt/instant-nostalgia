class Metadata
  def initialize(metadata)
    @metadata = metadata
  end

  def has_location?
    @metadata['GPSLatitude'].present?
  end

  def latitude
    "#{@metadata['GPSLatitude']}, #{@metadata['GPSLatitudeRef']}"
  end

  def longitude
    "#{@metadata['GPSLongitude']}, #{@metadata['GPSLongitudeRef']}"
  end

  def date_time_digitized
    output = DateTime.strptime(@metadata['DateTime'], '%Y:%m:%d %H:%M:%S') if @metadata['DateTime']
    output ||= Time.now.strftime('%Y:%m:%d %H:%M:%S')
    output
  end
end
