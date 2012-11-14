class BB.Views.CnTbodyRosterOpPeriods extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterOpPeriod

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model      # Event
    @collection = @model.periods     # Periods
    @bindTo(@collection, 'change remove reset', @render,    this)
    @bindTo(BB.vent,     'cmd:SetActivePeriod', @setActive, this)

  onShow: ->
    tmpFunc = => @collection.initActive()
    setTimeout(tmpFunc, 250)
    setTimeout(tmpFunc, 1000)
    setTimeout(tmpFunc, 5000)


  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    collectionView.$el.append(itemView.el)

  # ----- methods -----

  setActive: (id) ->
    @collection.setActive(id)
