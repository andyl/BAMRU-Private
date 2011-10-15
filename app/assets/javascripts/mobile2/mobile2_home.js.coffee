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

transcon = (label, pageid, el) ->
  localStorage[label] = el.data(label)
  $.mobile.changePage(pageid)

$('.memlink, .mem_home').live "tap", ->
  transcon('memid', '#member', $(this))
$('.memlink, .mem_home').live "swipeleft", ->
  transcon('memid', '#member', $(this))
$('.msglink, .msg_home').live "tap", ->
  transcon('msgid', '#message', $(this))
$('.msglink, .msg_home').live "swipeleft", ->
  transcon('msgid', '#message', $(this))

$('#roster, #status, #send-page, #message-log').live "swiperight", ->
  history.back()
$('#inbox, #member, #message').live "swiperight", ->
  history.back()

$('.home_nav').live "swipeleft", ->
  tag = $(this).attr('href')
  $.mobile.changePage(tag)
