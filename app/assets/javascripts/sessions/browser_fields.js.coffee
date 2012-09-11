# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  $('#browser_type').attr('value', BrowserDetect.browser)
  $('#browser_version').attr('value', BrowserDetect.version)
  $('#agent').attr('value',  navigator.userAgent)
  $('#ostype').attr('value', BrowserDetect.OS)
  $('#javascript').attr('value', true)
  $('#cookies').attr('value', navigator.cookieEnabled)
  $('#screen_height').attr('value', screen.height)
  $('#screen_width').attr('value',  screen.width)
