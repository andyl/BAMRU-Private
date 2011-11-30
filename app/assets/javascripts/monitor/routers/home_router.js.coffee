window.pageName = (page) ->
  switch page
    when "#home"     then "System Monitor"
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

class @Monitor_BaseRoute extends Backbone.Router
  routes :
    "home"         : "home"
    ""             : "home"
    "*actions"     : "default"
  home        : -> window.renderPage "#home"
