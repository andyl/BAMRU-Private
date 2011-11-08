window.pageName = (page) ->
  switch page
    when "#member"   then "Member Detail"
    when "#members"  then "Roster"
    when "#home"     then "BAMRU Mobile"
    when "#status"   then "Status Line"
    when "#messages" then "Message Log"
    when "#message"  then "Message"
    when "#inbox"    then "My Inbox"
    when "#send"     then "Send Page"
    when "#default"  then "Not Found"
    else page

window.setHeight = ->
  return if window.desktopOrIpadDevice()
  $('#wrapper').css("height", '')
  tgtHeight = window.innerHeight + 50
  if tgtHeight > document.body.clientHeight
    $('#wrapper').css("height", window.innerHeight)

window.renderPage = (page) ->
  $(".page").hide()
  if page == "#home"
    $(".back").hide()
  else
    $(".back").show()
  $("#label").html("<b>#{pageName(page)}</b>")
  $(page).show()
  setHeight()
  setTimeout('scrollSetup()', 100)
  setTimeout('hideUrlBar()', 300)

class @M3_BaseRoute extends Backbone.Router
  routes :
    "members"      : "members"
    "members/:id"  : "member"
    "status"       : "status"
    "test"         : "test"
    "send"         : "send"
    "messages"     : "messages"
    "messages/:id" : "message"
    "inbox"        : "inbox"
    "home"         : "home"
    ""             : "home"
    "*actions"     : "default"
  home        : -> 
    window.renderPage "#home"
    window.setState()
  members     : ->
    window.renderPage "#members"
    miv = new M3_MembersIndexView
    miv.render()
  member      : (id) ->
    memb = members.get(id)
    view = new M3_MemberShowView({model: memb})
    window.renderPage "#member"
    $('#member').html(view.render().el)
  status      : -> window.renderPage "#status"
  send        : -> window.renderPage "#send"
  messages    : ->
    window.renderPage "#messages"
    miv = new M3_MessagesIndexView
    miv.render()
  message     : (id) ->
    memb = messages.get(id)
    view = new M3_MessageShowView({model: memb})
    window.renderPage "#message"
    $('#message').html(view.render().el)
  inbox       : ->
    window.renderPage "#inbox"
    view = new M3_DistributionsIndexView
    view.render()
  default     : -> window.renderPage "#default"
