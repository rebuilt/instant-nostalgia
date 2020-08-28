class Gps
  def to_degrees(coordinates)
    Coordinates.new(convertDMSToDD(coordinates.latitude), convertDMSToDD(coordinates.longitude))
  end

  def convertDMSToDD(coordinate)
    units = parse(coordinate)
    decimal = units[:degrees] + units[:minutes] / 60 + units[:seconds] / 3600
    decimal *= -1 if units[:direction] == 'S' || units[:direction] == 'W'
    decimal
  end

  def parse(coordinate)
    coordinate = coordinate.split(',')
    output = {}
    output[:degrees] = divide(coordinate[0])
    output[:minutes] = divide(coordinate[1])
    output[:seconds] = divide(coordinate[2])
    output[:direction] = coordinate[3].strip
    output
  end

  def divide(statement)
    numbers = statement.split('/')
    (numbers[0].to_f / numbers[1].to_f)
  end
end

Coordinates = Struct.new(:latitude, :longitude)
