#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.createCookie = (name, value, days) ->
  if days
    date = new Date()
    date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
    expires = "; expires=" + date.toGMTString()
  else
    expires = ""
  document.cookie = name + "=" + value + expires + "; path=/"

window.readCookie = (name) ->
  nameEQ = name + "="
  ca = document.cookie.split(";")
  i = 0

  while i < ca.length
    c = ca[i]
    c = c.substring(1, c.length)  while c.charAt(0) is " "
    return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
    i++
  null

window.eraseCookie = (name) ->
  createCookie name, "", -1

# this code resets the logged in state
#window.applicationCache.addEventListener "downloading", ->
#  console.log window.localStorage.getItem("logged_in")
#  window.localStorage.setItem("logged_in", 'true')
#  window.localStorage.setItem("super", 'true')
#  window.localStorage.setItem("duper", 'true')
#  window.sessionStorage.setItem("logged_in", 'true')
#  window.sessionStorage.setItem("super", 'true')
#  window.sessionStorage.setItem("duper", 'true')
#  console.log "DOWNLOADING..."

window.deviceName = ->
  return "Kindle"      if navigator.userAgent.match /Kindle/
  return "Firefox"     if navigator.userAgent.match /Firefox/
  return "Chrome"      if navigator.userAgent.match /Chrome/
  return "Android"     if navigator.userAgent.match /Android/
  return "iPod"        if navigator.userAgent.match /iPod/
  return "iPhone"      if navigator.userAgent.match /iPhone/
  return "iPad"        if navigator.userAgent.match /iPad/
  return "BlackBerry"  if navigator.userAgent.match /BlackBerry/
  return "IE"          if navigator.userAgent.match /MSIE/
  return "Silk"        if navigator.userAgent.match /Silk/
  return "Safari"      if navigator.userAgent.match /Safari/
  return "Opera"       if navigator.userAgent.match /Opera/
  return "Netscape"    if navigator.userAgent.match /Netscape/
  return "Konqueror"   if navigator.userAgent.match /Konqueror/
  "Unknown"

window.isPhone = ->
  window.deviceName() in ["Android", "BlackBerry", "iPhone", "Chrome"]

window.mobileDevice = ->
  window.deviceName() in ["Silk", "Kindle", "Android", "BlackBerry", "iPhone", "iPod"]

window.touchDevice = ->
  window.deviceName() in ["Silk", "Kindle", "Android", "BlackBerry", "iPhone", "iPad", "iPod", "Chrome"]

window.iDevice = ->
  window.deviceName() in ["iPhone", "iPad", "iPod"]

window.iScrollDevice = ->
  window.deviceName() in ["iPad"]

window.topDevice = ->
  window.deviceName() in ["Android", "iPad", "iPod", "iPhone", "Silk", "Kindle"]

window.browserDevice = ->
  window.deviceName() in ["Firefox", "Chrome", "IE", "Safari", "Netscape"]

window.desktopOrIpadDevice = ->
  window.browserDevice() || window.iScrollDevice()

$(document).ready ->
  window.App = new Monitor_BaseRoute()
  Backbone.history.start()

window.myScroll = undefined

window.scrollSetup = ->
  return unless window.iScrollDevice()
  args = {momentum: true, hScrollbar: false, vScrollbar: true}
  if window.myScroll == undefined
    window.myScroll = new iScroll('wrapper', args)
  window.myScroll.refresh()

window.hideUrlBar = ->
  window.scrollTo(0,1)

window.noDefault = (e) -> e.preventDefault()

window.wrapperProps =
  'position': 'absolute'
  'z-index':  '1'
  'top':      '60px'
  'bottom':   '0'
  'left':     '0'
  'width':    '100%'
  'overflow': 'auto'

window.headerProps =
  'position': 'absolute'
  
window.configurePage = ->
  if window.desktopOrIpadDevice()
    document.documentElement.style.overflow = 'hidden'
    document.body.scroll = 'no'
    document.documentElement.style.overflowX = 'hidden'
    $('#wrapper').css(window.wrapperProps)
    $('header').css(window.headerProps)

window.scrollStop = ->
  if window.pageYOffset < 100
    window.hideUrlBar()
  window.scrollActive = false

$(document).ready ->
  window.configurePage()
  setTimeout('scrollSetup()', 100)
  setTimeout('hideUrlBar()', 1000)
  if window.touchDevice()
    $(document).bind('touchmove', -> noDefault(e))
  window.scrollActive = false
  $(window).bind 'swipeDown', ->
    return if scrollActive
    scrollActive = true
    setInterval("scrollStop()", 2000)

$(document).ready ->
  $('#logout').click ->
    window.localStorage.setItem("logged_in", 'false')
    window.location = "/monitor/logout"

$(document).ready ->
  sv = new Monitor_SnapshotsIndexView()
  sv.render()
  ev = new Monitor_EventsIndexView()
  ev.render()
