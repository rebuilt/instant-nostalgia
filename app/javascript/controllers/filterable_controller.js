import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['source', 'filterable'];

  filter(event) {
      let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase()

      this.filterableTargets.forEach((item) => {
          let filterableKey = item.getAttribute('data-filter-key')
          if (!filterableKey.includes(lowerCaseFilterTerm)) {
              item.style.display = 'none'
          } else {
              item.style.display = 'flex'
          }
      })
  }
}
