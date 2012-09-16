window.BbvShow = Backbone.View.extend

  el: "#event_overview"

  template: "#bb_show_template"

  genTemplate: ->
    context = _.extend({}, @model.toJSON(), @model.viewHelpers)
    _.template($(@template).html(), context)

  render: ->
    @$el.html(@genTemplate())
    @
