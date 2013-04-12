class BB.Views.CnTbodyOverviewShow extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyOverviewShow'

  templateHelpers: BB.Helpers.CnTbodyOverviewShowHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model
    @bindTo(BB.vent, 'click:CnTabsOverviewDeleteHotKey', @deleteEv, this)
    @bindTo(BB.vent, 'click:CnTabsOverviewCloneHotKey',  @clone,    this)
    @bindTo(BB.Collections.events, 'change add remove',  @render,   this)

  events:
    'click #CnTabsOverviewShow-edit'   : "edit"
    'click #CnTabsOverviewShow-clone'  : "clone"
    'click #CnTabsOverviewShow-delete' : "deleteEv"

  onShow: ->
    BB.hotKeys.enable("CnTbodyOverviewShow")

  onClose: ->
    BB.hotKeys.disable("CnTbodyOverviewShow")

  # ----- actions -----

  edit: (event) ->
    event.preventDefault()
    BB.vent.trigger("click:CnTabsOverviewEdit")

  clone: (event) ->
    event?.preventDefault()
    BB.vent.trigger("click:CnTabsOverviewClone", @model)

  deleteEv: (event) ->
    event?.preventDefault()
    answer = confirm("Are you sure you want to delete this event?")
    if answer == true
      BB.vent.trigger("click:CnTabsOverviewDelete")