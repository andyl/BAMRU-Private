class @Monitor_EventsIndexView extends Backbone.View
  el: "#xevents"
  render: =>
    $(@el).html("")
    events.each (event) ->
      view = new Monitor_EventIndexView({model: event})
      $("#xevents").append(view.render().el)
    @