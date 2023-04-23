ready = ->
  $("[data-toggle=tooltip]").tooltip()

$(document).on('turbolinks:load', ready)
