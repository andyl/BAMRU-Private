# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

# ----- Adds a label on the home page to show online/offline status -----
window.setStateOn  = -> $('#state').text("Online")
window.setStateOff = -> $('#state').text("Offline")
window.setState = (event, ui) ->
  if navigator.onLine then setStateOn() else setStateOff()

$(window).bind("pageshow", setState)
$(window).bind("online",  -> setStateOn)
$(window).bind("offline", -> setStateOff)
