#= require bchat/models/chat

class @BC1_Chats extends Backbone.Collection
  model: BC1_Chat
  url:   "/api/bchats"