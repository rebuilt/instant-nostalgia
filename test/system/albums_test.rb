require 'application_system_test_case'
include ActionDispatch::TestProcess

class AlbumsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    sign_in(create_user)
    visit albums_path

    assert_selector 'h1', text: 'Albums'
  end

  test 'create album' do
    sign_in(create_user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    assert page.has_content? title
  end

  test 'album controls - album button redirects to album#show' do
    sign_in(create_user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    album = Album.last
    within "#album-#{album.id}" do
      click_on album.title
    end

    assert_current_path album_path(id: album.id)
  end

  test 'album controls - view button redirects to album#show' do
    sign_in(create_user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    album = Album.last
    within "#album-#{album.id}" do
      click_on 'View'
    end

    assert_current_path album_path(id: album.id)
  end

  test 'album controls - Share album redirects to share#new' do
    user = create_user
    sign_in(user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    album = Album.last
    within "#album-#{album.id}" do
      click_on 'Share album'
    end

    assert current_url.include? new_share_path
  end

  test 'album controls - delete album removes album from page' do
    user = create_user
    sign_in(user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    album = Album.last
    within "#album-#{album.id}" do
      click_on 'Remove album'
    end
    page.driver.browser.switch_to.alert.accept
    assert 0, all("#album-#{album.id}").count
    assert_current_path albums_path
  end

  test 'add photo to album' do
    user = create_user
    sign_in(user)
    photo = create_photo_with_attachment(user)
    visit albums_path
    title = 'My first album'
    fill_in :album_title, with: title
    click_on 'Create Album'

    album = Album.last
    select album.title, from: 'album-selector'
    check "checked_#{photo.id}"
    click_on 'Add to album'
    assert current_url.include? album_path(id: album.id)
  end
end
