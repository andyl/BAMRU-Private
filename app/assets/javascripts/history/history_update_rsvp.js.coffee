# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

window.clickRSVP = (link) ->
  link_id = $(link).attr('id')
  [resp, dist_id] = link_id.split('_')
  data = {dist: {rsvp_answer: resp}, _method: "PUT"}
  url = "/history/#{dist_id}"
  $.post(url, data)
  setTimeout("window.location.reload()", 750)

$(document).ready ->
  $('.rsvp_yn').click -> clickRSVP(this)

