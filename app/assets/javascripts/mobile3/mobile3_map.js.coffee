# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

navError = (msg = "failed") ->
  errTxt = typeof msg == 'string' ? msg : "failed"
  $("#loc").text(errTxt)

window.getLocationAndDrawMap = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(showMap, navError)
  else
    $("#loc").text("not supported")

window.mapOpts = (latlon) ->
  center:            latlon
  zoom:              12
  navigationControl: false
  streetViewControl: false
  mapTypeControl:    false
  zoomControl:       true #
  mapTypeId:         google.maps.MapTypeId.ROADMAP
  navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}

window.showMap = (position) ->
  el  = document.getElementById("canvas")
  lat = position.coords.latitude
  lon = position.coords.longitude
  latlon = new google.maps.LatLng(lat, lon)
  latstr = "#{lat}".substring(0,7)
  lonstr = "#{lon}".substring(0,9)
  $('#coords').text("#{latstr} / #{lonstr}")
  $('#canvas').height($(window).height() - 140)
  gmap   = new google.maps.Map(el, mapOpts(latlon))
  mark   = new google.maps.Marker({position:latlon, map: gmap, title: ""})
