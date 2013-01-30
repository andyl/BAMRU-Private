class @M4_MessagesIndexView extends Backbone.View
  el: "#messages"
  render: =>
    $(@el).html("")
    messages.each (message) ->
      view = new M4_MessageIndexView({model: message})
      $("#messages").append(view.render().el)
    @