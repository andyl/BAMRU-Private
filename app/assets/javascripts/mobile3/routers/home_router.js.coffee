window.pageName = (page) ->
  switch page
    when "#member"      then "Member Detail"
    when "#members"     then "Roster"
    when "#home"        then "BAMRU Mobile"
    when "#status"      then "Status Line"
    when "#messages"    then "Message Log"
    when "#message"     then "Message"
    when "#page_select" then "Send Page"
    when "#page_send"   then "Send Page"
    when "#inbox"       then "My Inbox"
    when "#profile"     then "My Profile"
    when "#default"     then "Not Found"
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

class @M3_BaseRoute extends Backbone.Router
  routes :
    "members"      : "members"
    "members/:id"  : "member"
    "status"       : "status"
    "test"         : "test"
    "page_select"  : "page_select"
    "page_send"    : "page_send"
    "messages"     : "messages"
    "messages/:id" : "message"
    "inbox"        : "inbox"
    "profile"      : "profile"
    "location"     : "location"
    "home"         : "home"
    ""             : "home"

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
  page_select : -> window.renderPage "#page_select"
  page_send   : -> window.renderPage "#page_send"
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
  profile     : -> window.renderPage "#profile"
  default     : -> window.renderPage "#default"
