import { Controller } from 'stimulus'

export default class extends Controller {
    initialize() {
        this.element[this.identifier] = this
    }

    createModal(data) {
        const modalContent = document.createElement('div')
        modalContent.setAttribute('id', 'modal-content')
        modalContent.setAttribute('class', 'modal-content')

        const span = document.createElement('span')
        span.setAttribute('class', 'close')
        span.textContent = 'CLOSE X'

        const image = document.createElement('img')
        image.setAttribute('alt', `${data.latitude}, ${data.longitude}`)
        image.setAttribute('width', '100%')
        image.setAttribute('src', data.img_lg)

        modalContent.appendChild(span)
        modalContent.appendChild(image)

        span.addEventListener('click', () => {
            document.getElementById('modal-content').remove()
            const modal = document.getElementById('modal')
            modal.style.display = 'none'
        })
        return modalContent
    }

    show() {
        const modal = document.getElementById('modal')
        modal.style.display = 'block'
    }
    hide() {
        const modal = document.getElementById('modal')
        modal.style.display = 'none'
    }
}
