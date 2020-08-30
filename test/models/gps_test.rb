require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'gps converts a degree/minute/second coordinate to a decimal degree coordinate' do
    gps = Gps.new
    lats = [
      ' 46/1, 25/1, 151212/10000, N '
    ]
    longs = [
      ' 6/1, 55/1, 262117/10000, E '
    ]
    expected_lats = [
      46.420866999999994
    ]
    expected_longs = [
      6.923947694444445
    ]
    lats.each_with_index do |lat, i|
      conversion(lat, longs[i], expected_lats[i], expected_longs[i])
    end
  end

  def conversion(latitude, longitude, expected_latitude, expected_longitude)
    coordinates = Coordinates.new(latitude, longitude)
    gps = Gps.new
    coordinates = gps.to_decimal(coordinates)

    assert_in_delta coordinates.latitude, expected_latitude, 0.01
    assert_in_delta coordinates.longitude, expected_longitude, 0.01
  end
end
