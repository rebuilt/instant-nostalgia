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
        image.setAttribute('alt', `${data.id}`)
        image.setAttribute('width', '100%')
        image.setAttribute('src', data.img_lg)

        modalContent.appendChild(span)
        modalContent.appendChild(image)

        span.addEventListener('click', this.hide())
        return modalContent
    }

    show(content) {
        const modalDiv = document.getElementById('modal')
        modalDiv.appendChild(content)
        modalDiv.style.display = 'block'
    }

    hide() {
        let behavior = function () {
            document.getElementById('modal-content').remove()
            const modalDiv = document.getElementById('modal')
            modalDiv.style.display = 'none'
        }
        return behavior
    }
}
