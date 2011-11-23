
class @C2_ChatsIndexView extends Backbone.View
  el: "#chat"
  render: =>
    $(@el).html("")
    chats.each (chat) ->
      view = new C2_ChatIndexView({model: chat})
      $("#chat").append(view.render().el)
    @