require 'application_system_test_case'

class MapsTest < ApplicationSystemTestCase
  test 'registered user visiting the index' do
    sign_in(create_user)
    visit maps_path
    assert_current_path maps_path
    assert page.has_content? I18n.t('controllers.maps.recent')
  end

  test 'anonymous user visits index' do
    user = create_user
    create_album(user)
    visit maps_path
    assert page.has_content? 'Default public album'
  end

  test 'anonymous user can click on public album' do
    user = create_user
    album = create_album(user)
    album.public = true
    album.save

    visit maps_path
    click_on 'Open Public albums'
    page.check("publicAlbum[#{album.id}]")
    click_on 'Filter'
    assert page.has_content? "Results for | publicAlbum: #{album.title}"
  end

  test 'anonymous user can click on multiple public albums' do
    user = create_user
    album = create_album(user)
    album.public = true
    photo0 = create_photo(0, user)
    album.photos << photo0
    album.save

    user2 = create_user('bob')
    album2 = create_album(user2)
    album2.public = true
    photo1 = create_photo(1, user)
    album2.photos << photo1
    album2.save
    visit maps_path
    click_on 'Open Public albums'
    page.check("publicAlbum[#{album.id}]")
    page.check("publicAlbum[#{album2.id}]")
    click_on 'Filter'
    assert page.has_content? "Results for | publicAlbum: #{album.title} | publicAlbum: #{album2.title}"
    assert page.find("#photo-#{photo0.id}")
    assert page.find("#photo-#{photo1.id}")
  end

  test 'registered user can click on public album  ' do
    user = create_user
    sign_in(user)
    album = create_album(user)
    album.public = true
    photo0 = create_photo(0, user)
    album.photos << photo0
    album.save

    visit maps_path
    click_on 'Open Public albums'
    page.check("publicAlbum[#{album.id}]")
    click_on 'Filter'
    assert page.has_content? "Results for | publicAlbum: #{album.title}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'registered user can click on multiple public albums  ' do
    user = create_user
    sign_in(user)
    album = create_album(user)
    album.public = true
    photo0 = create_photo(0, user)
    album.photos << photo0
    album.save

    user2 = create_user('bob')
    album2 = create_album(user2)
    album2.public = true
    photo1 = create_photo(1, user)
    album2.photos << photo1
    album2.save

    visit maps_path
    click_on 'Open Public albums'
    page.check("publicAlbum[#{album.id}]")
    page.check("publicAlbum[#{album2.id}]")
    click_on 'Filter'
    assert page.has_content? "Results for | publicAlbum: #{album.title}"
    assert page.has_content? "| publicAlbum: #{album2.title}"
    assert page.find("#photo-#{photo0.id}")
    assert page.find("#photo-#{photo1.id}")
  end

  test 'most recent photos show up for registered user' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    photo1 = create_photo(1, user)
    visit maps_path
    assert page.has_content? I18n.t('controllers.maps.recent')
    assert page.find("#photo-#{photo0.id}")
    assert page.find("#photo-#{photo1.id}")
  end

  test 'can filter by date' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    day = '10'
    month = '1'

    visit maps_path(params: { 'day-selector' => day, 'month-selector' => month })
    assert page.has_content? "Results for | Date: #{day}-#{month}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by city' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    visit maps_path(params: { city: { photo0.city => '1' } })
    assert page.has_content? "Results for | city: #{photo0.city}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by state' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    visit maps_path(params: { state: { photo0.state => '1' } })
    assert page.has_content? "Results for | state: #{photo0.state}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by country' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    visit maps_path(params: { country: { photo0.country => '1' } })
    assert page.has_content? "Results for | country: #{photo0.country}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by album' do
    user = create_user
    sign_in(user)
    album = create_album(user)
    album.save

    photo0 = create_photo(0, user)
    album.photos << photo0
    album.save

    visit maps_path
    click_on "Open #{I18n.t('global.albums')}"
    page.check("album[#{album.id}]")
    click_on 'Filter'
    assert page.has_content? "Results for | album: #{album.title}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by shared albums' do
    user = create_user
    user2 = create_user('you')
    album = Album.new(title: 'first', user: user)
    photo0 = create_photo(0, user)
    album.photos << photo0
    share = Share.new(user: user2, album: album, photo: photo0)
    share.save
    sign_in(user2)

    visit maps_path(params: { album: { album.id => '1' } })
    assert page.has_content? "Results for | album: #{album.title}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can filter by date range' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    visit maps_path params: { 'start-date' => { 'start-date(1i)' => '2018', 'start-date(2i)' => '1', 'start-date(3i)' => '' }, 'end-date' => { 'end-date(1i)' => '2019', 'end-date(2i)' => '1', 'end-date(3i)' => '' } }
    assert page.has_content? 'Results for | Date range: '
    assert page.find("#photo-#{photo0.id}")
  end

  test 'can view individual photo' do
    user = create_user
    sign_in(user)
    photo0 = create_photo(0, user)
    visit maps_path params: { 'photo_id' => photo0.id }
    assert page.has_content? "Results for | Photo: #{photo0.id}"
    assert page.find("#photo-#{photo0.id}")
  end

  test 'cannot view private photo' do
    user = create_user
    user2 = create_user(username: 'two')
    photo0 = create_photo(0, user)
    sign_in(user2)
    visit maps_path params: { 'photo_id' => photo0.id }
    assert page.has_content? "Results for | Photo: #{photo0.id}"
    assert_not page.has_selector?("#photo-#{photo0.id}")
  end

  test 'can view photo placed in public album' do
    user = create_user
    user2 = create_user(username: 'two')
    photo0 = create_photo(0, user)
    album = create_album(user)
    album.photos << photo0
    album.public = true
    album.save
    sign_in(user2)
    visit maps_path params: { 'photo_id' => photo0.id }
    assert page.has_content? "Results for | Photo: #{photo0.id}"
    assert page.has_selector?("#photo-#{photo0.id}")
  end

  test 'can view photo in a shared album' do
    user = create_user
    user2 = create_user(username: 'two')
    photo0 = create_photo(0, user)
    album = create_album(user)
    album.photos << photo0
    album.save
    Share.create(user: user2, album: album, photo: photo0)
    sign_in(user2)
    visit maps_path params: { 'photo_id' => photo0.id }
    assert page.has_content? "Results for | Photo: #{photo0.id}"
    assert page.has_selector?("#photo-#{photo0.id}")
  end

  test 'can use all filters' do
    user = create_user
    user2 = create_user('you')
    album = Album.new(title: 'first', user: user)
    photo0 = create_photo(0, user)
    album.photos << photo0
    share = Share.new(user: user2, album: album, photo: photo0)
    share.save
    sign_in(user2)

    album2 = create_album(user)
    album2.public = true
    album2.save

    day = '10'
    month = '1'
    visit maps_path params: {
      'day-selector' => day,
      'month-selector' => month,
      city: { photo0.city => '1' },
      state: { photo0.state => '1' },
      country: { photo0.country => '1' },
      publicAlbum: { album2.id => '1' },
      album: { album.id => '1' },
      'start-date' => { 'start-date(1i)' => '2018',
                        'start-date(2i)' => '1',
                        'start-date(3i)' => '' },
      'end-date' => { 'end-date(1i)' => '2019',
                      'end-date(2i)' => '1',
                      'end-date(3i)' => '' }
    }
    assert page.has_content? "| Date: #{day}-#{month}"
    assert page.has_content? '| Date range: '
    assert page.has_content? "| album: #{album.title}"
    assert page.has_content? "| city: #{photo0.city}"
    assert page.has_content? "| state: #{photo0.state}"
    assert page.has_content? "| country: #{photo0.country}"
    assert page.find("#photo-#{photo0.id}")
  end
end
