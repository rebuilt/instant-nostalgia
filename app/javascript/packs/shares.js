const Shares = {}

let resultsElement

function getResultsElement(){
    if(resultsElement == null){
        resultsElement = document.getElementById('results')
    }
    return resultsElement
}

Shares.addTermDiv = function(term){
    const h3 = document.createElement('h3')
    h3.setAttribute('class', 'mr-3')
    h3.textContent = 'You searched for:'

    const span = document.createElement('span')
    span.setAttribute('id', 'term')
    span.textContent = term

    const results = getResultsElement()
    results.appendChild(h3)
    results.appendChild(span)
}

Shares.addHeaderDiv = function(){
    let headerDiv = document.getElementById('headerDiv')
    if(headerDiv == null){
        headerDiv = document.createElement('div')
        headerDiv.setAttribute('id', 'headerDiv')
        headerDiv.setAttribute('class', 'three-column-grid mt-4')

        const username = document.createElement('h3')
        username.textContent = 'Username'

        const email = document.createElement('h3')
        email.textContent = 'Email'

        const action = document.createElement('h3')
        action.textContent = 'Action'

        headerDiv.appendChild(username)
        headerDiv.appendChild(email)
        headerDiv.appendChild(action)

        const results = getResultsElement()
        results.appendChild(headerDiv)
    }
}

Shares.clearResultsDiv = function() {
    const results = getResultsElement()
    while(results.hasChildNodes()){
        results.removeChild(results.lastChild)
    }
}

Shares.addResults = function(users, album, locale){
    const results = getResultsElement()
    users.forEach((user) => {
        const row = document.createElement('div')
        row.setAttribute('class', 'three-column-grid mt-3')

        const username = document.createElement('p')
        username.setAttribute('class', 'mr-5')
        username.textContent = user.username

        const email = document.createElement('p')
        email.setAttribute('class', 'mr-5')
        email.textContent = user.email

        const action = document.createElement('a')
        action.setAttribute('class', 'btn btn--primary')
        action.setAttribute('rel', 'nofollow')
        action.setAttribute('data-method', 'post')
        action.setAttribute('href', `/${locale}/shares?album_id=${album.id}&amp;user_id=${user.id}` )
        action.textContent = `Share ${album.title} with ${user.username}`

        row.appendChild(username)
        row.appendChild(email)
        row.appendChild(action)

        results.appendChild(row)
    })
}

window.Shares = Shares
