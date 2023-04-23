ready = ->
  $('[data-increment]').on 'click', ->
    button = $(this)
    input = button.parent().parent().find('input[type=number]')
    newVal = Math.max(
      parseInt(input.val()) + parseInt(button.data('increment')),
      input.attr('min')
    )
    input.val newVal

    if input.data('warning')
      tr = input.closest '.tr'
      leftover = parseInt tr.find('.leftover').val()
      if newVal > leftover
        tr.addClass 'alert'
      else
        tr.removeClass 'alert'

$(document).on('turbolinks:load', ready)
