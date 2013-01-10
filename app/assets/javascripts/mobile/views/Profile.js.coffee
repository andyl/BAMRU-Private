class BB.Views.Profile extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template : 'mobile/templates/Profile'

  events:
    "click #logout"  : "logout"

  onRender: ->
    $('.clickHome').show()

  # ----- event handlers -----

  logout: (ev) ->
    ev.preventDefault()
    window.localStorage.setItem("logged_in", 'false')
    window.location = "/mobile/logout"