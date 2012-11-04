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
    @eventLinks     = new BB.Collections.EventLinks()
    @eventLinks.url = "/eapi/events/#{@.id}/event_links"
    @periods     = new BB.Collections.Periods()
    @periods.url = "/eapi/events/#{@.id}/periods"