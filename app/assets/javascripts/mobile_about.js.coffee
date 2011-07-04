# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

navError = (msg = "failed") ->
  errTxt = typeof msg == 'string' ? msg : "failed"
  $("#loc").text(errTxt)

navSuccess = (position) ->
  return if $("#loc_row").hasClass("success")
  lat = position.coords.latitude
  lon = position.coords.longitude
  $("#loc_row").html("<td align=right>Lat:</td><td>#{lat}</td>")
  $("#loc_row").after("<tr><td align=right>Lon:</td><td>#{lon}</td></tr>")
  $("#loc_row").addClass("success")

deviceName = ->
  ua = navigator.userAgent
  return "Android"    if ua.match(/Android/)
  return "iPod"       if ua.match(/iPod/)
  return "iPad"       if ua.match(/iPad/)
  return "iPhone"     if ua.match(/iPhone/)
  return "BlackBerry" if ua.match(/BlackBerry/)
  return "Firefox"    if ua.match(/Firefox/)
  return "Chrome"     if ua.match(/Chrome/)
  return "Safari"     if ua.match(/Safari/)
  return "Opera"      if ua.match(/Opera/)
  "Unknown"

getSize = ->
  "#{$(document).height()}H x #{$(document).width()}W"

$(document).ready ->
  $("#device").text(deviceName())

$(document).ready ->
  $("#size").text(getSize())
  $(window).resize ->
    $("#size").text(getSize())

$(document).ready ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(navSuccess, navError)
  else
    $("#loc").text("not supported")
