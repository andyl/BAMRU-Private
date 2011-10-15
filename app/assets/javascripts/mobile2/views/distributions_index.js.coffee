class @DistributionsIndexView extends Backbone.View
  el: "#distribution_index"
  render: =>
    $(@el).html("")
    _(inbox).each (dist) ->
      view = new DistributionIndexView({model: dist})
      $("#distribution_index").append(view.render().el)
    $(@el).listview()
    @