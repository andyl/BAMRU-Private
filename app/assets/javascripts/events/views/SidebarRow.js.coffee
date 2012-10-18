class BB.Views.SidebarRow extends Backbone.Marionette.ItemView

  template: 'events/templates/SidebarRow'

  templateHelpers: BB.Helpers.SidebarRowHelpers

  tagName: 'tr'

  events:
    "click": "clickRow"

  initialize: ->
    @$el.attr('id', "model_#{@model.get('id')}")
    @bindTo(@model, 'change', @render, this)

  clickRow: (event) ->
    event.preventDefault()
    BB.Routers.app.navigate("/events/#{@model.get('id')}", {trigger: true})
