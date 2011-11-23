#= require chats

window.updateChatDisplay = (json) ->
  obj  = JSON.parse json
  tmpl = "<li>#{obj.text}<span class='created_at'>#{obj.short_name} | #{obj.created_at}</span></li>"
  console.log tmpl
  $('#chat').append(tmpl)
  window.resizeChatList()

#= require ./chat2-faye

window.clearText = ->
  $('#chat_text').attr('value','')

$(document).ready ->
  view = new C2_ChatsIndexView
  view.render()
  $('input[value=Send]').click ->
    setTimeout('clearText()', 250)
