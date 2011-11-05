class @M2_MessagesIndexView extends Backbone.View
  el: "#message_index"
  render: =>
    $(@el).html("")
    messages.each (message) ->
      view = new M2_MessageIndexView({model: message})
      $("#message_index").append(view.render().el)
    $(@el).listview("refresh")
    @