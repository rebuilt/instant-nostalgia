require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'gps converts a degree/minute/second coordinate to a decimal degree coordinate' do
    gps = Gps.new
    lats = [
      ' 46/1, 25/1, 151212/10000, N ',
      '46/1, 26/1, 141960/10000, N ',
      '51/1, 30/1, 22188/10000, N ',
      '34/1, 5/1, 556631/10000, N '
    ]
    longs = [
      ' 6/1, 55/1, 262117/10000, E ',
      '6/1, 55/1, 298926/10000, E ',
      ' 0/1, 10/1, 395402/10000, W ',
      '118/1, 10/1, 567245/10000, W '

    ]
    expected_lats = [
      46.420866999999994,
      46.43727666666666,
      51.50061633333333,
      34.098795305555555
    ]
    expected_longs = [
      6.923947694444445,
      6.924970166666667,
      -0.17765005555555555,
      -118.18242347222223
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
