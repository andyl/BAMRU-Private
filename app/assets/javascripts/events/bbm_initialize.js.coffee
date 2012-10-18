# ----- Use JST Templates -----

Backbone.Marionette.Renderer.render = (template, data) -> JST[template](data)

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
  BB.Views.utilHeaderLeft  = new BB.Views.UtilHeaderLeft()
  BB.Views.utilHeaderRight = new BB.Views.UtilHeaderRight()
  BB.Views.utilNavbar      = new BB.Views.UtilNavbar()
  BB.Routers.app           = new BB.Routers.AppRouter()
  BB.hotKeys               = new BB.HotKeys.KeySets()
  Backbone.history.start({pushState: true})
#  Backbone.history.start()

# ----- Init BB after document.ready -----

$(document).ready ->
  BB.start()
