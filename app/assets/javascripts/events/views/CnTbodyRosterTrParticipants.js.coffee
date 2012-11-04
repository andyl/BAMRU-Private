class BB.Views.CnTbodyRosterTrParticipants extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterTrParticipant

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model                    # Period
    @collection = options.collection               # Participants
    @$el        = $("#participants#{@model.id}")
    @bindTo(@collection, 'reset',  @render, this)

  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    $(itemView.el).find("td").css('font-size', '8pt')
    collectionView.$el.append(itemView.el)

  # ----- methods -----

