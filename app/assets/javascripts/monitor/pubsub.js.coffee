window.updateSnapshots = (json) ->
  mod = _.min(snapshots.models, (modd) -> modd.get('id'))
  snapshots.remove(mod)
  obj = JSON.parse json
  snapshots.add([obj])
  nv = new Monitor_SnapshotsIndexView
  nv.render()

window.updateEvents = (json) ->
  mod = _.min(events.models, (modd) -> modd.get('id'))
  events.remove(mod)
  obj = JSON.parse json
  events.add([obj])
  ev = new Monitor_EventsIndexView
  ev.render()

$(document).ready ->
  faye = new Faye.Client(faye_server)
  faye.subscribe("/monitor/snapshots", (data) -> updateSnapshots(data))
  faye.subscribe("/monitor/events", (data) -> updateEvents(data))
