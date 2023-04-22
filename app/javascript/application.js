import "@hotwired/turbo-rails"

import "./jquery"
import "./controllers"
import * as bootstrap from "bootstrap"

$(document).on('ready turbo:load', function() {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
});
