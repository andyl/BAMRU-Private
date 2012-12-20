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
    @eventFiles     = new BB.Collections.EventFiles()
    @eventReports   = new BB.Collections.EventReports()
    @periods        = new BB.Collections.Periods()
    @updateCollectionUrls()
    @bind("change:id", @updateCollectionUrls)

  updateCollectionUrls: ->
    @eventLinks.url   = "/eapi/events/#{@.id}/event_links"
    @eventPhotos.url  = "/eapi/events/#{@.id}/event_photos"
    @eventFiles.url   = "/eapi/events/#{@.id}/event_files"
    @eventReports.url = "/eapi/events/#{@.id}/event_reports"
    @periods.url      = "/eapi/events/#{@.id}/periods"

  # ----- instance methods -----

  rowPub:   -> if @get('published') then "+" else "~"
  rowTyp:   -> @get('typ')[0].toUpperCase()
  rowTitle: -> _.string.truncate(@get('title'), 12)
  rowLoc:   -> _.string.truncate(@get('location'), 12)
  rowStart: -> moment(@get('start'))?.strftime("%Y-%m-%d")

  rowText: ->
    "#{@rowPub()} #{@rowTyp()} #{@rowTitle()} #{@rowLoc()} #{@rowStart()}"
