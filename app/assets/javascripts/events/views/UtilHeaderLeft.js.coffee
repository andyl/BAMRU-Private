class BB.Views.UtilHeaderLeft extends Backbone.Marionette.ItemView

  el: "#header_left"

  initialize: (options) ->
    @$el.addClass("bb-UtilHeaderLeft")
    @bindTo(BB.vent, 'show:CnTabs', @showLogoWithLink, this)
    @bindTo(BB.vent, 'show:CnIndx', @showLogo, this)

  showLogoWithLink: ->
    navEl = $('<b><a href="/events">Events</a></b>')
    @$el.html(navEl)
    navEl.click (event) => @linkToCnIndx(event)

  showLogo: ->
    @$el.html("<b>Events</b>")

  linkToCnIndx: (event) ->
    event.preventDefault()
    BB.vent.trigger "key:Home"
