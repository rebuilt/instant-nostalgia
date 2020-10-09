// direct_uploads.js

addEventListener('direct-upload:initialize', (event) => {
    const { target, detail } = event
    const { id, file } = detail
    const submit = document.getElementById('upload')
    submit.disabled = true
    target.insertAdjacentHTML(
        'beforebegin',
        `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
  `
    )
    target.previousElementSibling.querySelector(
        '.direct-upload__filename'
    ).textContent = file.name
})

addEventListener('direct-upload:start', (event) => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.remove('direct-upload--pending')
})

addEventListener('direct-upload:progress', (event) => {
    const { id, progress } = event.detail
    const progressElement = document.getElementById(
        `direct-upload-progress-${id}`
    )
    progressElement.style.width = `${progress}%`
})

addEventListener('direct-upload:error', (event) => {
    event.preventDefault()
    const { id, error } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add('direct-upload--error')
    element.setAttribute('title', error)
})

addEventListener('direct-upload:end', (event) => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add('direct-upload--complete')
})

addEventListener('direct-uploads:end', (event) => {
    const status = document.getElementById('status')
    status.innerHTML =
    '<a class="btn btn--primary max-content mt-3" href="/en/photos">View photos</a>'
    document.getElementById('upload').style.display = 'none'
    const message = document.getElementById('message')
    message.textContent =
    'Images uploaded.  Address information will continue to process in the background.  If latitude and longitude show up as "0", then no address information is embedded in the image.'
})
