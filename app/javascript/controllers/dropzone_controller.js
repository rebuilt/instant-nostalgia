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
          maxFiles: '100',
          maxFilesize: '20',
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
          const upload_btn = document.getElementById('upload')
          upload_btn.style.display = 'block'
          upload_btn.disabled = false
          upload_btn.addEventListener('click', function () {
              // const controls = document.getElementById('upload-controls')
              // controls.style.display = 'none'
              // const result = document.getElementById('result')
              // result.style.display = 'block'
          })
      })
  }

  get url() {
      return this.inputTarget.getAttribute('data-direct-upload-url')
  }
}
