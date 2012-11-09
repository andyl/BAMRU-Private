class BB.Views.CnTbodyRosterOpPeriods extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterOpPeriod

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model      # Event
    @collection = @model.periods     # Periods

  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    collectionView.$el.append(itemView.el)

  # ----- methods -----

