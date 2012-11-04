class BB.Views.CnTbodyRosterOpParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model       # Participant

  events:
    'click .deleteParticipant' : 'deleteParticipant'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()
