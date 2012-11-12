class BB.Views.CnIndx extends Backbone.Marionette.ItemView

  template: 'events/templates/CnIndx'

  templateHelpers: BB.Helpers.CnIndxHelpers

  initialize: (options) ->
    @bindTo(BB.Collections.events, 'change add remove', @render, this)

  events:
    'click .eventRowLink' : 'clickEvent'

  onShow: ->
    BB.vent.trigger("show:CnIndx")

  clickEvent: (event) ->
    event?.preventDefault()
    el = $(event.target)
    link = el.attr('href') || el.parent('.eventRowLink').attr('href')
    BB.Routers.app.navigate(link, {trigger: true})