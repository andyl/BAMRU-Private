window.backboneInitialize = ->
  console.log "Running backboneInitialize"
  window.event_params = JSON.parse($('#event-json').text())
  window.bEvent = new BamEvent(event_params)
  window.bShowView = new BamShowView({model:bEvent})
  bShowView.render()
