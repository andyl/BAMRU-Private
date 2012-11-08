class BB.Models.UiState extends Backbone.Model

  initialize: ->
    @readStateFromLocalStorage()
    @bind("change", @stateChanged)

  stateChanged: ->
    @saveStateToLocalStorage()
    BB.vent.trigger("uiState:changed", @)

  validSet: (params) ->
    if mDate(params.finish) < mDate(params.start)
      [params.start, params.finish] = [params.finish, params.start]
    @set(params, {silent: true})

  resetState: ->
    opts =
      start      : moment().subtract('months', 3).strftime("%b-%Y")
      finish     : moment().add('months', 8).strftime("%b-%Y")
      meeting    : true
      training   : true
      operation  : true
      community  : true
      social     : true
    @clear silent: true
    @set opts

  readStateFromLocalStorage: ->
    @resetState()
    savedAttributes = JSON.parse(localStorage.getItem('uiState'))
    _.extend(@attributes, savedAttributes)

  saveStateToLocalStorage: ->
    jsonAttributes = JSON.stringify(@toJSON())
    localStorage.setItem('uiState', jsonAttributes)
