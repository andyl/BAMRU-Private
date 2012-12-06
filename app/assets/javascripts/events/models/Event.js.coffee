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
    @eventPhotos    = new BB.Collections.EventPhotos()
    @eventFiles    = new BB.Collections.EventFiles()
    @periods        = new BB.Collections.Periods()
    @updateCollectionUrls()
    @bind("change:id", @updateCollectionUrls)

  updateCollectionUrls: ->
    @eventLinks.url  = "/eapi/events/#{@.id}/event_links"
    @eventPhotos.url = "/eapi/events/#{@.id}/event_photos"
    @eventFiles.url  = "/eapi/events/#{@.id}/event_files"
    @periods.url     = "/eapi/events/#{@.id}/periods"
