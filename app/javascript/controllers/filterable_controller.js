import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['source', 'filterable'];

  filter(event) {
      let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase()
      console.log(lowerCaseFilterTerm)

      this.filterableTargets.forEach((el) => {
          let filterableKey = el.getAttribute('data-filter-key')
          console.log(el)
          console.log(!filterableKey.includes(lowerCaseFilterTerm))
          if (!filterableKey.includes(lowerCaseFilterTerm)) {
              el.style.display = 'none'
          } else {
              el.style.display = 'flex'
          }
      })
  }
}
