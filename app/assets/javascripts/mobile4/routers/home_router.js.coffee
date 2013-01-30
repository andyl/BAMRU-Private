window.pageName = (page) ->
  switch page
    when "#member"   then "Member Detail"
    when "#members"  then "Roster"
    when "#home"     then "BAMRU Mobile 4"
    when "#status"   then "Status Line"
    when "#messages" then "Message Log"
    when "#message"  then "Message"
    when "#send"     then "Send Page"
    when "#inbox"    then "My Inbox"
    when "#profile"  then "My Profile"
    when "#location" then "My Location"
    when "#default"  then "Not Found"
    else page

window.setHeight = ->
  return if window.desktopOrIpadDevice()
  $('#wrapper').css("height", '')
  tgtHeight = window.innerHeight + 50
  if tgtHeight > document.body.clientHeight
    $('#wrapper').css("height", window.innerHeight)

window.unbindListeners = ->
#  $(window).removeAttr('resize')

window.renderPage = (page) ->
  unbindListeners()
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

class @M4_BaseRoute extends Backbone.Router
  routes :
    "members"      : "members"
    "members/:id"  : "member"
    "status"       : "status"
    "test"         : "test"
    "send"         : "send"
    "messages"     : "messages"
    "messages/:id" : "message"
    "inbox"        : "inbox"
    "profile"      : "profile"
    "location"     : "location"
    "home"         : "home"
    ""             : "home"
    "*actions"     : "default"
  home        : -> 
    window.renderPage "#home"
    window.setState()
  members     : ->
    window.renderPage "#members"
    miv = new M4_MembersIndexView
    miv.render()
  member      : (id) ->
    memb = members.get(id)
    view = new M4_MemberShowView({model: memb})
    window.renderPage "#member"
    $('#member').html(view.render().el)
  status      : -> window.renderPage "#status"
  send        : -> window.renderPage "#send"
  messages    : ->
    window.renderPage "#messages"
    miv = new M4_MessagesIndexView
    miv.render()
  message     : (id) ->
    memb = messages.get(id)
    view = new M4_MessageShowView({model: memb})
    window.renderPage "#message"
    $('#message').html(view.render().el)
  inbox       : ->
    window.renderPage "#inbox"
    view = new M4_DistributionsIndexView
    view.render()
  profile     : -> window.renderPage "#profile"
  location    : ->
    window.renderPage "#location"
    window.getLocationAndDrawMap()
    $(window).resize -> getLocationAndDrawMap()
  default     : -> window.renderPage "#default"
