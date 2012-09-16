window.backboneInitialize = ->
  window.event_params = JSON.parse($('#event-json').text())
  window.bbmEvent = new BbmEvent(event_params)
  window.bbvShow = new BbvShow({model:bbmEvent})
  window.bbvEdit = new BbvEdit({model:bbmEvent})
  bbvShow.render()
  $('#overview-edit-link').click -> bbvEdit.render()
