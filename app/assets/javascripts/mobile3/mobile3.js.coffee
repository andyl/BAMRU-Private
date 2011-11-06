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

$(document).ready ->
  window.App = new M3_BaseRoute()
  Backbone.history.start()
  window.scrollTo 0, 1  if window.mobileDevice()
  document.body.addEventListener "offline", -> setState()
  document.body.addEventListener "online",  -> setState()
