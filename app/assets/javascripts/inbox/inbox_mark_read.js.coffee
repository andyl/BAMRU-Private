# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

window.processClick = (link) ->
  link_id = $(link).attr('id')
  dist_id = link_id.split('_',2)[1]
  data = {dist: {read: true}, _method: "PUT"}
  url  = "/history/#{dist_id}"
  $.post(url, data)
  window.location.reload()

$(document).ready ->
  $('.markready').click -> processClick(this)
