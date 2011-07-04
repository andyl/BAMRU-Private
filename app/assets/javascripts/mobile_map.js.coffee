# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

navError = (msg = "failed") ->
  errTxt = typeof msg == 'string' ? msg : "failed"
  $("#loc").text(errTxt)

getLocationAndDrawMap = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(showMap, navError)
  else
    $("#loc").text("not supported")

mapOpts = (latlon) ->
  center:            latlon
  zoom:              12
  mapTypeControl:    true
  navigationControl: false
  streetViewControl: true
  zoomControl:       true
  mapTypeId:         google.maps.MapTypeId.ROADMAP
  navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}

showMap = (position) ->
  offset = {top: 80, left: 15}
  margin = 30
  lat = position.coords.latitude
  lon = position.coords.longitude
  latlon = new google.maps.LatLng(lat, lon)
  $('#coords').text("#{lat} / #{lon}")
  $('#canvas').height($(document).height() - offset.top  - margin)
  $('#canvas').width($(document).width()   - offset.left - margin)
  $('#canvas').gmap(mapOpts(latlon))
  $('#canvas').gmap('addMarker', {'position':latlon, 'title':'You are here!'})

$(document).ready ->
  getLocationAndDrawMap()
  $(window).resize -> getLocationAndDrawMap()
