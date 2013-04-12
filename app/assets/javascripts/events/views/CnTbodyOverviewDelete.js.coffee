class BB.Views.CnTbodyOverviewDelete extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyOverviewDelete'

  templateHelpers: ->
    base = { periods: @model.periods }
    _.extend(base, BB.Helpers.CnTbodyOverviewShowHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model

  events:
    'click #noDelete'   : "cancel"
    'click #yesDelete'  : "deleteEv"

  # ----- actions -----

  cancel: (event) ->
    event?.preventDefault()
    BB.vent.trigger("click:CnTabsOverviewShow", @model)

  deleteEv: (event) ->
    event?.preventDefault()
    debugger
    @model.destroy()
    BB.vent.trigger("click:CnTabsOverviewDelete")
    BB.Routers.app.navigate('/events', {trigger: true})
