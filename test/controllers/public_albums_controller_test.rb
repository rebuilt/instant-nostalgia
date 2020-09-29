require 'test_helper'

class PublicAlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_albums_index_url
    assert_response :success
  end

end
