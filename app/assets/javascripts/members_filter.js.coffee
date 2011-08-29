# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#rsa_check').prop("checked", true) if readCookie("rsa_show") == "true"
  $('#rsa_check').click ->
    if $('#rsa_check').is(':checked')
      createCookie("rsa_show", "true")
    else
      createCookie("rsa_show", "false")
    refresh_url = window.location.href.split('?', 1) + "?refresh=true"
    window.location.assign(refresh_url)