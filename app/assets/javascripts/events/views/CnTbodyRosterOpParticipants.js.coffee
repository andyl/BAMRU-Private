class BB.Views.CnTbodyRosterOpParticipants extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterOpParticipant

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model                    # Period
    @collection = options.collection               # Participants
    @$el        = $("#participants#{@model.id}")
    @bindTo(@collection, 'change',    @render, this)



