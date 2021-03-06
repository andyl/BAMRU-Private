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
    @setActive(@last()?.id) if @getActive().length == 0

  clearActive: -> @each (m) -> m.unset('isActive') if m.get('isActive')

  getActive:   -> @select (m) -> m.get('isActive')

  setActive: (modelId) ->
    @clearActive()
    lclModel = @get(modelId)
    lclModel?.set({isActive: true})

