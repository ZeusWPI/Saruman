import { StreamActions } from '@hotwired/turbo'

StreamActions.dispatch_event = function() {
  const name = this.getAttribute('name')
  const event = new Event(name)
  const target = this.getAttribute('target')
  window.dispatchEvent(event)
}
