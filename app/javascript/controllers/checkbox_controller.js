import { Controller } from 'stimulus'

export default class extends Controller {
    selectAll() {
        var inputs = document.querySelectorAll('input[type=\'checkbox\']')
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].checked = true
        }
    }

    selectNone() {
        var inputs = document.querySelectorAll('input[type=\'checkbox\']')
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].checked = false
        }
    }
}
