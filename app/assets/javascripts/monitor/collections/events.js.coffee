class @Monitor_Events extends Backbone.Collection
  model: Monitor_Event
  url:   "/api/monitor/events"
  comparator: (mod) ->
    mod.get('id') * -1