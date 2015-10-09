class BB.Models.RosterState extends Backbone.Model

  initialize: (eventId) ->
    @eventId = eventId
    @storageKey = "rosterState-#{@eventId}"
    @readStateFromLocalStorage(eventId)
    @bind("change", @stateChanged)

  stateChanged: ->
    @saveStateToLocalStorage()
    BB.vent.trigger("rosterState:changed", @)

  resetState: ->
    opts =
      updatedAt : moment()
      showTimes : "none"
    @clear silent: true
    @set opts

  readStateFromLocalStorage: ->
    @resetState()
    savedAttributes = JSON.parse(localStorage.getItem(@storageKey))
    _.extend(@attributes, savedAttributes)

  saveStateToLocalStorage: ->
    jsonAttributes = JSON.stringify(@toJSON())
    localStorage.setItem(@storageKey, jsonAttributes)

  saveToLocalStorage: -> @saveStateToLocalStorage()

  setView: (label) ->
    if _.contains("none transit signin".split(' '), label)
      @set(showTimes: label)
      return true
    false

  setPeriod: (period) ->
    return false if period == undefined
    _.each(Object.keys(@attributes), (att) => @attributes[att] = "min" if @attributes[att] == "max" )
    opts = {}
    opts[period] = "max"
    opts.active  = parseInt(period)
    @set(opts)
    true

  # ----- class method -----

  @cleanup: =>
    cutoff = moment().subtract('days', 4)
    keyList = Object.keys(localStorage)
    _.each keyList, (key) ->
      return unless key.split('-')[0] == "rosterState"
      rosterState = JSON.parse(localStorage.getItem(key))
      if cutoff < moment(rosterState.updatedAt)
        localStorage.removeItem(key)