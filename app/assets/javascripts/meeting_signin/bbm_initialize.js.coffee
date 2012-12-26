# ----- Use JST Templates -----

Backbone.Marionette.Renderer.render = (template, data) -> JST[template](data)

# ----- Create Application -----

window.BB = new Backbone.Marionette.Application
  Collections : {}
  Models      : {}
  Routers     : {}
  Helpers     : {}
  Views       : {}
  HotKeys     : {}
  UI          : {}

# ----- Initializer -----

BB.addInitializer (options) ->
  BB.Routers.app           = new BB.Routers.AppRouter()
  Backbone.history.start({pushState: true})

# ----- Init BB after document.ready -----

$(document).ready ->
  BB.start()
