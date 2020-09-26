import { Controller } from 'stimulus'

export default class extends Controller {
    initialize() {
        this.element[this.identifier] = this
    }
}
