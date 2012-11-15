class BB.Views.CnTbodyRosterOpPeriods extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  itemView: BB.Views.CnTbodyRosterOpPeriod

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model      # Event
    @collection = @model.periods     # Periods
    @bindTo(@collection, 'remove reset',        @render,     this)
    @bindTo(BB.vent,     'cmd:SetActivePeriod', @setActive,  this)
    @bindTo(BB.vent,     'cmd:NextPeriod',      @nextPeriod, this)
    @bindTo(BB.vent,     'cmd:PrevPeriod',      @prevPeriod, this)

  onShow: ->
    tmpFunc = => @collection.initActive()
    setTimeout(tmpFunc, 500)

  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    collectionView.$el.append(itemView.el)

  # ----- methods -----

  setActive: (id) ->
    @collection.setActive(id)

  nextPeriod: ->
    return if @collection.length < 2
    oldMdl = @collection.getActive()[0]
    oldIdx = @collection.indexOf(oldMdl)
    newIdx = if oldIdx == @collection.length-1 then 0 else oldIdx+1
    newMdl = @collection.at(newIdx)
    @collection.setActive(newMdl.id)

  prevPeriod: ->
    return if @collection.length < 2
    oldMdl = @collection.getActive()[0]
    oldIdx = @collection.indexOf(oldMdl)
    newIdx = if oldIdx == 0 then @collection.length-1 else oldIdx-1
    newMdl = @collection.at(newIdx)
    @collection.setActive(newMdl.id)
