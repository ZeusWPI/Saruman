# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("#delete-confirm").on "show.bs.modal", ->
    $submit = $(this).find(".btn-danger")
    $submit.attr "href", $(this).data("link")

  $(".delete-confirm").click (e) ->
    e.preventDefault()
    $("#delete-confirm").data("link", $(this).data("link")).modal "show"

$(document).ready(ready)
$(document).on('page:load', ready)
