# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
ready = ->
  $("#item-edit-tooltip").tooltip()
  $(".reservation-disapprove-tooltip").tooltip()

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).on "click", ".btn-disapprove", (e) ->
  e.preventDefault()

  _self = $(this);
  $("#disapprove-id").val(_self.data('id'))

  $(_self.attr('href')).modal('show');
