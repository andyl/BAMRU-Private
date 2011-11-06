class @M3_DistributionsIndexView extends Backbone.View
  el: "#inbox"
  render: =>
    $(@el).html("")
    inbox.each (dist) ->
      view = new M3_DistributionIndexView({model: dist})
      $("#inbox").append(view.render().el)
    @