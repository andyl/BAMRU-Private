# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

mapData =
  destination: new google.maps.LatLng(59.3327881, 18.064488100000062)

mapOpts =
  'center'            : mapData.destination
  'zoom'              : 12
  'mapTypeControl'    : false
  'navigationControl' : false
  'streetViewControl' : false

showMap = ->
  offset = {top: 80, left: 15}
  margin = 30
  $('#canvas').height($(document).height() - offset.top  - margin)
  $('#canvas').width($(document).width()   - offset.left - margin)
  $('#canvas').gmap(mapOpts)

$(document).ready ->
  showMap()
  showMap()
  $(window).resize -> showMap()