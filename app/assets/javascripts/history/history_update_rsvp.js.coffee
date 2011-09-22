# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

window.clickRSVP = (link) ->
  link_id = $(link).attr('id')
  dist_id = link_id.split('_',2)[1]
  data = {dist: {read: true}, _method: "PUT"}
  url  = "/history/#{dist_id}"
  $.post(url, data)
  window.location.reload()

window.clickRSVPs = (link) ->
  link_id = $(link).attr('id')
  dist_id = link_id.split('_',2)[1]
  data = {dist: {read: true}, _method: "PUT"}
  url  = "/history/#{dist_id}"
  $.post(url, data)
  window.location.reload()

window.markAll = ->
  url  = "/history/markall"
  $.ajax
    url: url
  setTimeout("window.location.reload()", 2000)

window.clickRSVP = (link) ->
  link_id = $(link).attr('id')
  [resp, dist_id] = link_id.split('_')
  data = {dist: {rsvp_answer: resp}, _method: "PUT"}
  url = "/history/#{dist_id}"
  console.log url
  console.log data
  $.post(url, data)
  alert "waiting"
  window.location.reload()

$(document).ready ->
  $('.rsvp_yn').click -> clickRSVP(this)

