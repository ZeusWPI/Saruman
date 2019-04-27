# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".btn-action").click (e) ->
    $(".btn-action").removeClass("btn-primary").addClass("btn-default")
    $(this).addClass("btn-primary")

$(document).ready(ready)
$(document).on('page:load', ready)