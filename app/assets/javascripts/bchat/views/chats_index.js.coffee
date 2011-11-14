
class @BC1_ChatsIndexView extends Backbone.View
  el: "#chat"
  render: =>
    $(@el).html("")
    bchats.each (chat) ->
      view = new BC1_ChatIndexView({model: chat})
      $("#chat").append(view.render().el)
    @