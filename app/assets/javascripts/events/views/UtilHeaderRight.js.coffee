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
    return unless @model?
    title = @model.get('title')
    date  = moment(@model.get('start')).strftime("%Y-%b-%d")
    html = "<span class='activeEvent' style='padding-left: 6px; padding-right: 6px;'><b>#{title} #{date}</b></span>"
    @$el.html(html)

  hideTitle: -> @$el.html("")

