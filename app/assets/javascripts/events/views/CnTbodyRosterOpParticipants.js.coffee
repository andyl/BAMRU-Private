class BB.Views.CnTbodyRosterOpParticipants extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterOpParticipant

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model                    # Period
    @collection = options.collection               # Participants
    @$el        = $("#participants#{@model.id}")
    @bindTo(@collection, 'change remove reset', @render, this)

  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    $(itemView.el).find("td").css('font-size', '8pt')
    collectionView.$el.append(itemView.el)

  # ----- methods -----

