class BB.Views.Unrecognized extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Unrecognized'

  # ----- initialization -----

  initialize: (message) ->
    @model = new Backbone.Model()
    @model.set message: message

  onRender: ->
    @setLabel 'home'
    setTimeout(@initializePage, 1)

