backboneInitialize = ->
  console.log "Running backboneInitialize"
#  backbone_params = $('#json').text()
#  window.event = new Event(event_params)

$(document).on "pjax:end", -> backboneInitialize()