class @M3_DistributionsIndexView extends Backbone.View
  el: "#inbox"
  render: =>
    $(@el).html("")
    filtered_list = _.filter distributions.models, (mod) ->
      id = mod.get('message_id')
      messages.get(id) != undefined
    if filtered_list.length == 0
      $("#inbox").append("<div class='center'>No Recent Inbox Messages</div>")
      return @
    distributions.each (dist) ->
      view = new M3_DistributionIndexView({model: dist})
      $("#inbox").append(view.render().el)
    @