class BB.Collections.Periods extends Backbone.Collection

  model: BB.Models.Period

  initialize: ->
    @on('remove', @resetPositions)

  comparator: (period) -> period.get('position')

  resetPositions: ->
    @each (el, idx) -> el.save position: idx + 1