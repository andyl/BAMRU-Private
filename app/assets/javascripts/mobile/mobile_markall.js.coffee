# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

markAll = ->
  url  = "/history/markall"
  $.ajax
    url: url
  setTimeout("window.location.reload()", 1500)

$(document).ready ->
  $('#markall').click -> markAll()