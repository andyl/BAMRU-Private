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

# ----- Set default classNames for all views -----

oldConfig = Backbone.Marionette.View.prototype._configure
Backbone.Marionette.View.prototype._configure = (options) ->
  newClass = "bb-#{@.constructor.name}"
  @className = if @className?
    [newClass].concat(@className.split(' ')).join(' ')
  else
    newClass
  oldConfig.call(this, options)

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
  BB.Views.utilFooter      = new BB.Views.UtilFooter()
  BB.Views.utilHeaderLeft  = new BB.Views.UtilHeaderLeft()
  BB.Views.utilHeaderRight = new BB.Views.UtilHeaderRight()
  BB.Views.utilNavbar      = new BB.Views.UtilNavbar()
  BB.Routers.app           = new BB.Routers.AppRouter()
  Backbone.history.start({pushState: true})

# ----- Init BB after document.ready -----

$(document).ready ->
  BB.start()
