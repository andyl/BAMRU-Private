class BB.Views.UtilNavbar extends Backbone.Marionette.ItemView

  el: "#hnEvents"

  initialize: (options) ->
    @$el.addClass("bb-UtilNavbar")
    @bindTo(BB.vent, 'show:CnTabs', @showLink, this)
    @bindTo(BB.vent, 'show:CnIndx', @hideLink, this)

  showLink: ->
    navEl = $('<a href="/events" id="event_nav">Events</a>')
    @$el.html(navEl)
    navEl.click (event) => @linkToCnIndx(event)

  hideLink: ->
    @$el.html("Events")

  linkToCnIndx: (event) ->
    event.preventDefault()
    BB.Routers.app.navigate("/events", {trigger: true})
