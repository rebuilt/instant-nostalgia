class Gps
  def to_decimal(coordinates)
    Coordinates.new(convertDMSToDD(coordinates.latitude), convertDMSToDD(coordinates.longitude))
  end

  private

  def convertDMSToDD(coordinate)
    units = parse(coordinate)
    decimal = calculate(units)
    decimal = add_sign(decimal, units)
    decimal
  end

  def add_sign(decimal, units)
    # Add a negative sign if direction is south or west.  Do nothing otherwise
    decimal *= -1 if units[:direction] == 'S' || units[:direction] == 'W'
    decimal
  end

  def calculate(units)
    units[:degrees] + units[:minutes] / 60 + units[:seconds] / 3600
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