class BB.Views.CnTbodyRosterMtParticipants extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterMtParticipant

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model                    # Period
    @collection = options.collection               # Participants
    @$el        = $("#participants#{@model.id}")
    @bindTo(@collection, 'change remove reset', @render, this)

  # ----- construction -----

  # ----- methods -----

