import { Controller } from 'stimulus'
import Dropzone from 'dropzone'
import 'dropzone/dist/min/dropzone.min.css'
import 'dropzone/dist/min/basic.min.css'
import { DirectUpload } from '@rails/activestorage'

export default class extends Controller {
  static targets = ['input'];

  connect() {
      Dropzone.autoDiscover = false
      this.inputTarget.disable = true
      this.inputTarget.style.display = 'none'
      const dropzone = new Dropzone(this.element, {
          url: '/', // this does not actually get used but it's required
          maxFiles: '100',
          maxFilesize: '25',
          autoQueue: false,
          acceptedFiles: '.png, .jpg, .jpeg',
          timeout: 6000000,
      })

      dropzone.on('addedfile', (file) => {
          const submitBtn = document.getElementById('submit-btn')
          submitBtn.style.visibility = 'hidden'
          setTimeout(() => {
              if (file.accepted) {
                  const upload = new DirectUpload(file, this.url)
                  upload.create((error, blob) => {
                      this.hiddenInput = document.createElement('input')
                      this.hiddenInput.type = 'hidden'
                      this.hiddenInput.name = this.inputTarget.name
                      this.hiddenInput.value = blob.signed_id
                      this.inputTarget.parentNode.insertBefore(
                          this.hiddenInput,
                          this.inputTarget.nextSibling
                      )
                      dropzone.emit('success', file)
                      dropzone.emit('complete', file)
                      file.complete = true
                      console.log(upload)
                  })
              }
          }, 500)
      })

      dropzone.on('complete', function (file) {
          console.log('files have finished uploading')
          const submitBtn = document.getElementById('submit-btn')
          submitBtn.style.visibility = 'visible'
          submitBtn.addEventListener('click', function () {
              const result = document.getElementById('result')
              result.style.visibility = 'visible'
              const uploadControls = document.getElementById('upload-controls')
              uploadControls.style.display = 'none'
              submitBtn.style.visibility = 'hidden'
          })
      })
  }

  get url() {
      return this.inputTarget.getAttribute('data-direct-upload-url')
  }
}
