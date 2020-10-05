require 'application_system_test_case'

class SharesTest < ApplicationSystemTestCase
  test 'visiting the index' do
    sign_in(create_user)
    visit shares_path
    assert_selector 'h1', text: I18n.t('global.albums')
  end

  test 'To Shares button redirects to share#index' do
    user = create_user
    sign_in(user)
    album = create_album(user)
    visit shares_path

    assert_selector 'h1', text: I18n.t('global.albums')

    visit new_share_path(album_id: album.id)

    assert current_url.include? new_share_path

    click_on 'To Shares'
    assert_current_path shares_path
  end

  test 'Share button redirects to share#new' do
    user = create_user
    sign_in(user)
    album = create_album(user)
    visit shares_path

    assert_selector 'h1', text: I18n.t('global.albums')

    within "#album-#{album.id}" do
      click_on 'Share album'
    end

    assert current_url.include? new_share_path
  end

  test 'share album with another user' do
    user = create_user
    user2 = create_user('second_user')
    sign_in(user)
    album = create_album(user)
    visit new_share_path(album_id: album.id)

    assert current_url.include? new_share_path

    fill_in :search, with: user2.username
    click_on 'Search for User'
    assert page.has_content? user2.email

    click_on "Share #{album.title} with #{user2.username}"
    assert page.has_content? user2.email
    assert_current_path shares_path
  end

  test 'view button redirects to albums#show' do
    user = create_user
    user2 = create_user('second_user')
    sign_in(user)
    album = create_album(user)
    visit new_share_path(album_id: album.id)

    assert current_url.include? new_share_path

    fill_in :search, with: user2.username
    click_on 'Search for User'
    assert page.has_content? user2.email

    click_on "Share #{album.title} with #{user2.username}"
    assert page.has_content? user2.email
    assert_current_path shares_path
    click_on I18n.t('logout')
    sign_in(user2)
    visit shares_path

    within "#share-#{album.id}" do
      click_on 'View'
    end
    assert_current_path album_path(id: album)
  end
end
