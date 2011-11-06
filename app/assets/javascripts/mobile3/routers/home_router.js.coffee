window.pageName = (page) ->
  switch page
    when "#member"   then "Member Detail"
    when "#members"  then "Roster"
    when "#home"     then "BAMRU Mobile 3"
    when "/home"     then "BAMRU Mobile 3"
    when "#status"   then "Status Line"
    when "#messages" then "Message Log"
    when "#message"  then "Message"
    when "#inbox"    then "My Inbox"
    when "#send"     then "Send Page"
    when "#default"  then "Not Found"
    else page

window.render_page = (page) ->
  console.log page
  $(".page").hide()
  if page == "#home"
    $(".back").hide()
  else
    $(".back").show()
  $("#label").html("<b>#{pageName(page)}</b>")
  $(page).show()
  window.scrollTo 0, 1  if navigator.userAgent.match(/Android/i)

class @M3_BaseRoute extends Backbone.Router
  routes :
    "members"      : "members"
    "members/:id"  : "member"
    "status"       : "status"
    "send"         : "send"
    "messages"     : "messages"
    "messages/:id" : "message"
    "inbox"        : "inbox"
    "home"         : "home"
    "/home"        : "home"
    "/"            : "home"
    "#home"        : "home"
    ""             : "home"
    "*actions"     : "default"
  initialize  : -> console.log "LOADING"
  home        : -> window.render_page "#home"
  members     : ->
    window.render_page "#members"
    miv = new M3_MembersIndexView
    miv.render()
  member      : (id) ->
    memb = members.get(id)
    view = new M3_MemberShowView({model: memb})
    window.render_page "#member"
    $('#member').html(view.render().el)
  status      : -> window.render_page "#status"
  send        : -> window.render_page "#send"
  messages    : ->
    window.render_page "#messages"
    miv = new M3_MessagesIndexView
    miv.render()
  message     : (id) ->
    memb = messages.get(id)
    view = new M3_MessageShowView({model: memb})
    window.render_page "#message"
    $('#message').html(view.render().el)
  inbox       : -> window.render_page "#inbox"
  default     : -> window.render_page "#default"