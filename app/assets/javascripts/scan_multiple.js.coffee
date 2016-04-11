ready = ->
  $('#new_scan').submit (e) ->
    tr = $('.tr.alert')
    if tr.length > 0
      return confirm("Some of these items are not within limits. Please be sure.")
    else
      return true

$(document).ready(ready)
$(document).on('page:load', ready)
