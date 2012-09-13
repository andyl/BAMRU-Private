window.BamEvent = Backbone.Model.extend

  defaults:
    points: 0

  increment: ->
    @set 'points', @get('points') + 1
    this #for chaining

