require 'application_system_test_case'
include ActionDispatch::TestProcess

class PhotosTest < ApplicationSystemTestCase
  test 'visiting the index' do
    create_user
    sign_in
    visit photos_path
    assert_selector 'h1', text: 'Photos'
  end

  test 'visiting the index with a photo or more' do
    user = create_user
    sign_in
    create_photo_with_attachment(user)
    visit photos_path
    assert_selector 'h1', text: 'Photos'
    assert_equal 1, all('.photo-deletable').count
    assert page.has_content? 'Delete'

    create_photo_with_attachment(user)
    visit photos_path
    assert_equal 2, all('.photo-deletable').count

    create_photo_with_attachment(user)
    visit photos_path
    assert_equal 3, all('.photo-deletable').count
  end

  test 'can delete a photo' do
    user = create_user
    sign_in
    create_photo_with_attachment(user)
    visit photos_path
    assert_selector 'h1', text: 'Photos'
    assert_equal 1, all('.photo-deletable').count
    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    visit photos_path
    assert_equal 0, all('.photo-deletable').count
    assert_not page.has_content? 'Delete'
  end
end
