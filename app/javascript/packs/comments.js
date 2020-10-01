const Comments = {}

Comments.buildComment = function (comment) {
    const commentElement = document.createElement('li')
    commentElement.setAttribute('class', 'avatar')
    commentElement.setAttribute('id', comment.id)

    const comment__details = document.createElement('div')
    comment__details.setAttribute('class', 'comment__details')

    const avatar = document.createElement('img')
    avatar.setAttribute('alt', 'Avatar')
    avatar.setAttribute('class', 'avatar')
    avatar.setAttribute('src', comment.avatar_url)

    const time = document.createElement('time')
    time.setAttribute('datetime', comment.created_at)
    time.setAttribute('class', 'comment__time')
    time.textContent = comment.time_ago

    const comment__body = document.createElement('div')
    comment__body.setAttribute('class', 'trix-content')
    comment__body.textContent = comment.body

    const comment__name = document.createElement('span')
    comment__name.setAttribute('class', 'comment__name')
    comment__name.textContent = comment.first_name

    const delete_form = document.createElement('form')
    delete_form.setAttribute('class', 'button_to comment__delete')
    delete_form.setAttribute('method', 'post')
    delete_form.setAttribute('action', comment.comment_url)
    delete_form.setAttribute('data-remote', 'true')

    const hidden1 = document.createElement('input')
    hidden1.setAttribute('type', 'hidden')
    hidden1.setAttribute('name', '_method')
    hidden1.setAttribute('value', 'delete')

    const delete_button = document.createElement('input')
    delete_button.setAttribute('value', 'Delete')
    delete_button.setAttribute('type', 'Submit')

    const hidden2 = document.createElement('input')
    hidden2.setAttribute('type', 'hidden')
    hidden2.setAttribute('name', 'authenticity_token')
    hidden2.setAttribute('value', comment.authenticity_token)

    delete_form.appendChild(hidden1)
    delete_form.appendChild(delete_button)
    delete_form.appendChild(hidden2)

    comment__details.appendChild(avatar)
    comment__details.appendChild(comment__name)
    comment__details.appendChild(time)
    comment__details.appendChild(delete_form)

    commentElement.appendChild(comment__details)
    commentElement.appendChild(comment__body)
    return commentElement
}

Comments.addComment = function (comment) {
    const newComment = Comments.buildComment(comment)

    const commentList = document.getElementById('commentList')
    commentList.appendChild(newComment)
}

Comments.updateCommentCount = function (count, id) {
    const countElement1 = document.getElementById(id)
    countElement1.textContent = count
}

window.Comments = Comments
