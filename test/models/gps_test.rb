require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'gps converts a degree/minute/second coordinate to a decimal degree coordinate' do
    gps = Gps.new
    coordinates = Coordinates.new(' 46/1, 25/1, 308546/10000, N ', ' 6/1, 56/1, 9221/10000, E ')
    conversion(coordinates)
  end

  def conversion(coordinates)
    gps = Gps.new
    coordinates = gps.to_decimal(coordinates)

    assert_in_delta coordinates.latitude, 46.42523738888889, 0.01
  end
end
