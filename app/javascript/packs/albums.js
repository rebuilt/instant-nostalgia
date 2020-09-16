const Albums = {}

Albums.buildLinks = function(album){
    const listItem = document.createElement('li')
    listItem.setAttribute('class', 'row end mt-2')
    listItem.setAttribute('id', `album-${album.id}`)

    const title = document.createElement('h3')
    const titleLink = document.createElement('a')
    titleLink.setAttribute('class', 'btn')
    titleLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    titleLink.textContent = album.title
    title.appendChild(titleLink)

    const viewLink = document.createElement('a')
    viewLink.setAttribute('class', 'btn btn--primary no-radius')
    viewLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    viewLink.textContent = 'View'

    const shareLink = document.createElement('a')
    shareLink.setAttribute('class', 'btn btn--primary no-radius')
    shareLink.setAttribute('href', `/${album.locale}/shares/new?album_id=${album.id}`)
    shareLink.textContent = 'Share album'

    const removeLink = document.createElement('a')
    removeLink.setAttribute('class', 'btn btn--warning no-radius')
    removeLink.setAttribute('href', `/${album.locale}/albums/${album.id}`)
    removeLink.setAttribute('data-confirm', 'Are you sure?')
    removeLink.setAttribute('rel', 'nofollow')
    removeLink.setAttribute('data-method', 'delete')
    removeLink.textContent = 'Remove album'

    listItem.appendChild(title)
    listItem.appendChild(viewLink)
    listItem.appendChild(shareLink)
    listItem.appendChild(removeLink)

    return listItem
}

Albums.addLinks = function(album){
    const container = document.getElementById('albumList')
    const links = Albums.buildLinks(album)
    container.appendChild(links)
}

Albums.addToDropdown = function(album){
    const selector = document.getElementById('album-selector')
    const option = document.createElement('option')
    option.appendChild(document.createTextNode(album.title))
    option.value = album.id
    selector.appendChild(option)
}

Albums.clearInput = function(id){
    const input = document.getElementById(id)
    input.value = ''
}

Albums.removeElement = function(id){
    document.getElementById(id).remove()
}

window.Albums = Albums
