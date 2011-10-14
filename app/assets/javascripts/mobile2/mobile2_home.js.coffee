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


$('.memlink, .mem_home').live "click", ->
  localStorage['memID'] = $(this).data('memid')
$('.memlink, .mem_home').live "swipeleft", ->
  localStorage['memID'] = $(this).data('memid')
  $.mobile.changePage('#member')

$('#roster, #status, #send-page, #message-log, #inbox').live "swiperight", ->
  $.mobile.changePage('#home', {reverse: true})
$('#member').live "swiperight", ->
  $.mobile.changePage('#roster', {reverse: true})
$('#message').live "swiperight", ->
  $.mobile.changePage('#message-log', {reverse: true})

$('.home_nav').live "swipeleft", ->
  tag = $(this).attr('href')
  $.mobile.changePage(tag)
