#= require chat2/models/chat

class @C2_Chats extends Backbone.Collection
  model: C2_Chat
  url:   "/api/chat2"