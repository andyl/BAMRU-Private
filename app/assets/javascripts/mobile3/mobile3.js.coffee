#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

#window.Mobile3 =
#  Models: {}
#  Collections: {}
#  Routers: {}
#  Views: {}

window.setStateOn  = -> $('#state').text("Online")
window.setStateOff = -> $('#state').text("Offline")
window.setState = (event, ui) ->
  if navigator.onLine then setStateOn() else setStateOff()

window.returnSelf = (object) -> object

window.deviceName = ->
  return "Firefox"     if navigator.userAgent.match /Firefox/
  return "Chrome"      if navigator.userAgent.match /Chrome/
  return "Android"     if navigator.userAgent.match /Android/
  return "iPod"        if navigator.userAgent.match /iPod/
  return "iPhone"      if navigator.userAgent.match /iPhone/
  return "iPad"        if navigator.userAgent.match /iPad/
  return "BlackBerry"  if navigator.userAgent.match /BlackBerry/
  return "IE"          if navigator.userAgent.match /MSIE/
  return "Safari"      if navigator.userAgent.match /Safari/
  return "Opera"       if navigator.userAgent.match /Opera/
  return "Netscape"    if navigator.userAgent.match /Netscape/
  return "Konqueror"   if navigator.userAgent.match /Konqueror/
  "Unknown"

window.isPhone = ->
  window.deviceName() in ["Android", "BlackBerry", "iPhone", "Chrome"]

window.mobileDevice = ->
  window.deviceName() in ["Android", "BlackBerry", "iPhone", "iPod"]

window.touchDevice = ->
  window.deviceName() in ["Android", "BlackBerry", "iPhone", "iPad", "iPod", "Chrome"]

window.iDevice = ->
  window.deviceName() in ["iPhone", "iPad", "iPod"]

window.iScrollDevice = ->
  window.deviceName() in ["iPad"]

window.topDevice = ->
  window.deviceName() in ["Android", "iPad", "iPod", "iPhone"]

window.browserDevice = ->
  window.deviceName() in ["Firefox", "Chrome", "IE", "Safari", "Netscape"]

window.desktopOrIpadDevice = ->
  window.browserDevice() || window.iScrollDevice()

$(document).ready ->
  window.App = new M3_BaseRoute()
  Backbone.history.start()
  document.body.addEventListener "offline", -> setState()
  document.body.addEventListener "online",  -> setState()

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

$(document).ready ->
  window.configurePage()
  setTimeout('scrollSetup()', 100)
  setTimeout('hideUrlBar()', 1000)
  if window.touchDevice()
    $(document).bind('touchmove', -> noDefault(e))
