class BB.Views.CnTbodyRosterTrParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterTrParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterTrParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model       # Participant

  events:
    'click .deleteParticipant'       : 'deleteParticipant'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()
