class BB.Collections.Periods extends Backbone.Collection

  model: BB.Models.Period

  initialize: ->
    @bind('remove', @resetPositions)

  comparator: (period) -> period.get('position')

  # ----- period positions -----

  resetPositions: =>
    @each (el, idx) ->
      curPos = el.get('position')
      newPos = idx + 1
      el.save(position: newPos) unless curPos == newPos

  # ----- active period -----

  initActive:  ->
    @setActive(@last()?.id) unless @getActive()?

  clearActive: ->
    BB.UI.rosterState.unset('active')

  getActive:   ->
    @get(BB.UI.rosterState.get('active'))

  setActive: (modelId) ->
    BB.UI.rosterState.set(active: modelId)


