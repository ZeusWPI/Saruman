import "@hotwired/turbo-rails"

import "./jquery"
import "./controllers"
import "./custom_actions/dispatch_event"
import * as bootstrap from "bootstrap"

$(document).on('ready turbo:load', function() {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const _ = [...tooltipTriggerList].map(tooltipTriggerEl => {
    if(!bootstrap.Tooltip.getInstance(tooltipTriggerEl)) {
      new bootstrap.Tooltip(tooltipTriggerEl)
    }
  })
});
