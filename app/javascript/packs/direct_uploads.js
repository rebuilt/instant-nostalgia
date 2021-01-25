addEventListener('direct-upload:initialize', (event) => {
    console.log('in direct-upload initialize event')
    const { target, detail } = event
    const { id, file } = detail
    const directUpload = document.getElementById(`direct-upload-${id}`)
    if (directUpload === null) {
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
    }
})

addEventListener('direct-upload:start', (event) => {
    console.log('in direct-upload start event')
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.remove('direct-upload--pending')
})

addEventListener('direct-upload:progress', (event) => {
    console.log('in direct-upload progress event')
    const { id, progress } = event.detail
    const progressElement = document.getElementById(
        `direct-upload-progress-${id}`
    )
    progressElement.style.width = `${progress}%`
})

addEventListener('direct-upload:error', (event) => {
    console.log('in direct-upload error event')
    event.preventDefault()
    const { id, error } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add('direct-upload--error')
    element.setAttribute('title', error)
})

addEventListener('direct-upload:end', (event) => {
    console.log('in direct-upload end single event')
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add('direct-upload--complete')
})

addEventListener('direct-uploads:end', (event) => {
    console.log('in direct-upload end multiple event')
    const { target, detail } = event
    const { id, file } = detail
    const directUpload = document.getElementById(`direct-upload-${id}`)
    if (directUpload != null) {
        directUpload.parent.removeChild(directUpload)
    }
})

const fileSelect = document.getElementById('file-select')
fileSelect.addEventListener('change', function () {
    console.log('in fileselect event')
    const upload_btn = document.getElementById('upload')
    upload_btn.style.display = 'block'
})
