class BB.Views.Profile extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template : 'mobile/templates/Profile'

  onRender: ->
    $('.clickHome').show()