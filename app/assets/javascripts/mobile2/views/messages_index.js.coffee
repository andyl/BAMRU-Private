class @MessagesIndexView extends Backbone.View
  el: "#message_index"
  render: =>
    $(@el).html("")
    messages.each (message) ->
      view = new MessageIndexView({model: message})
      $("#message_index").append(view.render().el)
    $(@el).listview("refresh")
    @