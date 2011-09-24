# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.togglePage = (a_page, b_page)->
  $(a_page).show()
  $(b_page).hide()
  $("#{a_page}_link").attr("data-theme", "b")
  $("#{a_page}_link").removeClass("ui-btn-up-c").removeClass("ui-btn-hover-c")
  $("#{a_page}_link").addClass("ui-btn-up-b").addClass("ui-btn-hover-b")
  $("#{b_page}_link").attr("data-theme", "c")
  $("#{b_page}_link").removeClass("ui-btn-up-b").removeClass("ui-btn-hover-b")
  $("#{b_page}_link").addClass("ui-btn-up-c").addClass("ui-btn-hover-c")

displaySend   = -> togglePage("#send", "#select")
displaySelect = -> togglePage("#select", "#send")

$(document).ready ->
  $("#send_link").click   -> displaySend()
  $("#select_link").click -> displaySelect()
  displaySelect()
