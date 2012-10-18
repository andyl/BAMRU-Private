class BB.Views.CnMissingEvent extends Backbone.Marionette.ItemView

  template: 'events/templates/CnMissingEvent'

  initialize: (options) ->
    @model = new Backbone.Model()
    @model.set({options: options})
