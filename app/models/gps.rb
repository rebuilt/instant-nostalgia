class Gps
  def to_degrees(coordinates)
    Coordinates.new(convertDMSToDD(coordinates.latitude), convertDMSToDD(coordinates.longitude))
  end

  def convertDMSToDD(coordinate)
    units = parse(coordinate)
    puts units
    decimal = units[:degrees] + units[:minutes] / 60 + units[:seconds] / 3600
    decimal *= -1 if units[:direction] == 'S' || units[:direction] == 'W'
    decimal
  end

  def parse(coordinates)
    coordinates = coordinates.split(',')
    output = {}
    output[:degrees] = divide(coordinates[0])
    output[:minutes] = divide(coordinates[1])
    output[:seconds] = divide(coordinates[2])
    output[:direction] = coordinates[3].strip
    output
  end

  def divide(statement)
    numbers = statement.split('/')
    (numbers[0].to_f / numbers[1].to_f)
  end
end

Coordinates = Struct.new(:latitude, :longitude)
