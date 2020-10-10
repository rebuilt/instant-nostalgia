class Gps
  def self.to_decimal(coordinates)
    return Coordinates.new(0, 0) if coordinates.latitude == '0' || coordinates.longitude == '0'

    Coordinates.new(convertDMSToDD(coordinates.latitude), convertDMSToDD(coordinates.longitude))
  end

  def self.convertDMSToDD(coordinate)
    units = parse(coordinate)
    decimal = calculate(units)
    decimal = add_sign(decimal, units)
    decimal
  end

  def self.add_sign(decimal, units)
    # Add a negative sign if direction is south or west.  Do nothing otherwise
    decimal *= -1 if units[:direction] == 'S' || units[:direction] == 'W'
    decimal
  end

  def self.calculate(units)
    units[:degrees] + units[:minutes] / 60 + units[:seconds] / 3600
  end

  def self.parse(coordinate)
    coordinate = coordinate.split(',')
    output = {}
    output[:degrees] = divide(coordinate[0])
    output[:minutes] = divide(coordinate[1])
    output[:seconds] = divide(coordinate[2])
    coordinate[3] ||= ''
    output[:direction] = coordinate[3].strip
    output
  end

  def self.divide(statement)
    return 0 if statement.nil?

    numbers = statement.split('/')
    (numbers[0].to_f / numbers[1].to_f)
  end

  private_class_method :convertDMSToDD
  private_class_method :add_sign
  private_class_method :calculate
  private_class_method :parse
  private_class_method :divide
end

Coordinates ||= Struct.new(:latitude, :longitude)
