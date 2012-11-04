class BB.Views.CnIndx extends Backbone.Marionette.ItemView

  template: 'events/templates/CnIndx'

  templateHelpers: BB.Helpers.CnIndxHelpers

  initialize: (options) ->
    @bindTo(BB.Collections.events, 'change add remove', @render, this)

  onShow: ->
    BB.vent.trigger("show:CnIndx")

  events:
    "click .eventLink": "clickEvent"

  clickEvent: (event) ->
    event?.preventDefault()
    link = $(event.target).attr('href')
    BB.Routers.app.navigate(link, {trigger: true})