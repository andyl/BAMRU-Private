class @M3_DistributionsIndexView extends Backbone.View
  el: "#distribution_index"
  render: =>
    $(@el).html("")
    _(inbox).each (dist) ->
      view = new M3_DistributionIndexView({model: dist})
      $("#distribution_index").append(view.render().el)
    $(@el).listview()
    @