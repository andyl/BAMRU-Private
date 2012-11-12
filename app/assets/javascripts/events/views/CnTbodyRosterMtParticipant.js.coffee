class BB.Views.CnTbodyRosterMtParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterMtParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterMtParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model       # Participant
    @bindTo(@model, 'change', @render, this)

  events:
    'click .deleteParticipant'       : 'deleteParticipant'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()
