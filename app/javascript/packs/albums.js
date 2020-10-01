const Albums = {}

Albums.buildLinks = function (album) {
    const listItem = document.createElement('li')
    listItem.setAttribute('class', 'albums__item mt-3')
    listItem.setAttribute('id', `album-${album.id}`)

    const title = document.createElement('h3')
    const titleLink = document.createElement('a')
    titleLink.setAttribute('class', 'btn mr-1')
    titleLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    titleLink.textContent = album.title
    title.appendChild(titleLink)

    const viewLink = document.createElement('a')
    viewLink.setAttribute('class', 'btn btn--primary no-radius mr-1')
    viewLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    viewLink.textContent = 'View photos'

    const shareLink = document.createElement('a')
    shareLink.setAttribute('class', 'btn btn--primary no-radius mr-1')
    shareLink.setAttribute(
        'href',
        `/${album.locale}/shares/new?album_id=${album.id}`
    )
    shareLink.textContent = 'Share with a user'

    const removeLink = document.createElement('a')
    removeLink.setAttribute('class', 'btn btn--warning no-radius mr-1')
    removeLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    removeLink.setAttribute('data-confirm', 'Are you sure?')
    removeLink.setAttribute('rel', 'nofollow')
    removeLink.setAttribute('data-method', 'delete')
    removeLink.textContent = 'Delete album'

    const makePublic = document.createElement('a')
    makePublic.setAttribute('id', `public-status-button-${album.id}`)
    makePublic.setAttribute('class', 'btn btn--secondary mr-6')
    makePublic.textContent = 'Make this album public'

    const status = document.createElement('div')
    status.setAttribute('id', 'output')
    status.setAttribute('class', 'delta')
    status.setAttribute(
        'title',
        'If made public, this album will be viewable by all users. If private, this album will be visible only by users with which you have explicitly shared this album'
    )
    status.setAttribute('data-remote', 'true')
    status.setAttribute('data-method', 'post')
    status.setAttribute(
        'href',
        `/${album.locale}/albums/${album.id}/toggle_public`
    )
    status.textContent = 'PRIVATE ALBUM'

    listItem.appendChild(title)
    listItem.appendChild(viewLink)
    listItem.appendChild(shareLink)
    listItem.appendChild(removeLink)
    listItem.appendChild(makePublic)
    listItem.appendChild(status)

    return listItem
}

Albums.addLinks = function (album) {
    const container = document.getElementById('albumList')
    const links = Albums.buildLinks(album)
    container.appendChild(links)
}

Albums.addToDropdown = function (album) {
    const selector = document.getElementById('album-selector')
    const option = document.createElement('option')
    option.appendChild(document.createTextNode(album.title))
    option.value = album.id
    selector.appendChild(option)
}

window.Albums = Albums
