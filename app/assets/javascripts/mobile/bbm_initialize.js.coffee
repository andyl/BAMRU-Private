# ----- Use JST Templates -----

Backbone.Marionette.Renderer.render = (template, data) -> JST[template](data)

# ----- Incorporate Rails CSRF Protection -----

Backbone.old_sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  new_options = _.extend(
    beforeSend: (xhr) ->
      token = $("meta[name=\"csrf-token\"]").attr("content")
      xhr.setRequestHeader "X-CSRF-Token", token  if token
  , options)
  Backbone.old_sync method, model, new_options

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
