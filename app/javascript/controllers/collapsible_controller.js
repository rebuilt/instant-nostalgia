import { Controller } from 'stimulus'

export default class extends Controller {
    toggle(event) {
        let button = event.target
        button.classList.toggle('active')
        let panel = button.nextElementSibling
        if (panel.style.display === 'block') {
            panel.style.display = 'none'
            let title = button.textContent.split(' ')
            title[0] = 'Open'
            button.textContent = `${title.join(' ')}`
        } else {
            panel.style.display = 'block'
            let title = button.textContent.split(' ')
            title[0] = 'Close'
            button.textContent = `${title.join(' ')}`
            let input = panel.firstElementChild
            if (input.nodeName === 'INPUT') {
                input.focus()
                input.select()
            }
        }
    }
}
