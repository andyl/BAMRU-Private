window.render_page = (page) ->
  $(".page").hide()
  if page == "#home"
    $(".back").hide()
  else
    $(".back").show()
  $("#label").text(page)
  $(page).show()
  window.scrollTo 0, 1  if navigator.userAgent.match(/Android/i)

class @M3_BaseRoute extends Backbone.Router
  routes :
    "members"      : "members"
    "members/:id"  : "member"
    "duty"         : "duty"
    "status"       : "status"
    "send"         : "send"
    "messages"     : "messages"
    "messages/:id" : "message"
    "inbox"        : "inbox"
    "home"         : "home"
    ""             : "home"
    "*actions"     : "default"
  initialize  : -> console.log "LOADING"
  home        : -> window.render_page "#home"
  members     : ->
    window.render_page "#members"
    miv = new MembersIndexView
    miv.render()
  member      : (id) ->
    window.render_page "#member"
  duty        : -> window.render_page "#duty"
  status      : -> window.render_page "#status"
  send        : -> window.render_page "#send"
  messages    : ->
    window.render_page "#messages"
    miv = new MessagesIndexView
    miv.render()
  message     : (id) -> window.render_page "#message"
  inbox       : -> window.render_page "#inbox"
  default     : -> window.render_page "#default"