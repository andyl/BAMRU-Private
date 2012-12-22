class BB.Views.Home extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'meeting_signin/templates/Home'

  # ----- initialization -----

  events:
    "click .navLink"  : "navClick"

  # ----- instance methods -----

  navClick: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data('id')
    typ = $(ev.target).data('typ')
    BB.Routers.app.navigate("/meeting_signin/#{id}/#{typ}", {trigger: true})


