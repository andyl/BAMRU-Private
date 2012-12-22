class BB.Models.Event extends Backbone.Model

  # ----- configuration -----

  urlRoot: '/eapi/events'

  defaults: ->
    "start"    : moment().strftime("%Y-%m-%d")
    "title"    : "TBA"
    "location" : "TBA"

  # ----- initialization -----

  initialize: ->
    @periods        = new BB.Collections.Periods()
    @updateCollectionUrls()
    @bind("change:id", @updateCollectionUrls)

  updateCollectionUrls: ->
    @periods.url      = "/eapi/events/#{@.id}/periods"

  # ----- instance methods -----

  rowPub:   -> if @get('published') then "+" else "~"
  rowTyp:   -> @get('typ')[0].toUpperCase()
  rowTitle: -> _.string.truncate(@get('title'), 12)
  rowLoc:   -> _.string.truncate(@get('location'), 12)
  rowStart: -> moment(@get('start'))?.strftime("%Y-%m-%d")

  rowText: ->
    "#{@rowPub()} #{@rowTyp()} #{@rowTitle()} #{@rowLoc()} #{@rowStart()}"
