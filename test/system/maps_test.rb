require 'application_system_test_case'

class MapsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    sign_in(create_user)
    visit maps_path
    assert_current_path maps_path
  end
end
