class BB.Views.Status extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template : 'mobile/templates/Status'

  onRender: ->
    $('.clickHome').show()