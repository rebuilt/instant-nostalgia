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
          url: '/',
          maxFiles: '10',
          maxFilesize: '10',
          autoQueue: false,
      })

      dropzone.on('addedfile', (file) => {
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
                  })
              }
          }, 500)
      })
      dropzone.on('complete', function (file) {
          const upload = document.getElementById('upload')
          upload.style.display = 'block'
          upload.addEventListener('click', function () {
              const view = document.getElementById('view')
              if (view == null) {
                  const status = document.getElementById('status')
                  status.insertAdjacentHTML(
                      'beforebegin',
                      '<a id="view" class="btn btn--secondary max-content mt-3" href="/en/photos">View photos</a>'
                  )
                  document.getElementById('upload').style.display = 'none'
                  const message = document.getElementById('message')
                  message.textContent =
            'Images uploaded.  Address information will continue to process in the background.  If latitude and longitude show up as "0", then no address information is embedded in the image.'
              }
          })
      })
  }

  get url() {
      return this.inputTarget.getAttribute('data-direct-upload-url')
  }
}
