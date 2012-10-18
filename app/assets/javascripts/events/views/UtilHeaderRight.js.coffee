class BB.Views.UtilHeaderRight extends Backbone.Marionette.ItemView

  el: "#header_right"

  initialize: (options) ->
    @$el.addClass("bb-UtilHeaderRight")
    @bindTo(BB.vent, 'show:CnTabs', @showTitle, this)
    @bindTo(BB.vent, 'show:CnIndx', @hideTitle, this)

  showTitle: (model) ->
    @model = model
    @bindTo(@model, 'change:title', @updateTitle, this)
    @updateTitle()

  updateTitle: ->
    @$el.html(@model.get('title')) if @model?

  hideTitle: -> @$el.html("")

