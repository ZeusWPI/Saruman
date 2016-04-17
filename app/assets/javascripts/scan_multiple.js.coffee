ready = ->
  $('#new_scan').submit (e) ->
    tr = $('.tr.alert')
    if tr.length > 0
      return confirm("Some of these items are not within limits. Are you sure you want to continue?")
    else
      return true

$(document).ready(ready)
$(document).on('page:load', ready)
