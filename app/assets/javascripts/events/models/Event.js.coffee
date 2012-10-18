class BB.Models.Event extends Backbone.Model

  # ----- configuration -----

  urlRoot: '/eapi/events'

  defaults: ->
    "start"    : moment().strftime("%Y-%m-%d")
    "title"    : "TBA"
    "leaders"  : "TBA"
    "location" : "TBA"
    "all_day"  : true
    "published": false

  # ----- initialization -----

  initialize: ->
    @event_links = new BB.Collections.EventLinks()
    @event_links.url = "/eapi/events/#{@.id}/event_links"