# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ----- Select and Send Nav Bar -----

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
  displaySelect()
  $("#send_link").click   -> displaySend()
  $("#select_link").click -> displaySelect()

# ----- Positioning for Select and Clear Buttons -----

window.setBreak = ->
  width = $(document).width()
  if (width < 453)
    $('#wideLayout').hide()
    $('#narrowLayout').show()
  else
    $('#narrowLayout').hide()
    $('#wideLayout').show()

$(document).ready ->
  $(window).resize -> setBreak()
  setBreak()

# ----- Update Select Count -----

window.updateSelectCount = ->
  count = $('.rck:checked').length
  txt   = if count == 0 then "" else " (#{count})"
  $('#select_count').text(txt)
  mem_txt = if count == 0 then "0" else "#{count}"
  $('#pgr_submit').prev().children('.ui-btn-text').text("Send to #{mem_txt} members")

window.processClick = (ele) ->
  name = $(ele).attr("for")
  nele = $("##{name}")
  checked = nele.is(':checked')
  if checked then nele.prop("checked", false) else nele.prop("checked", true)
  updateSelectCount()
  if checked then nele.prop("checked", true) else nele.prop("checked", false)

$(document).ready ->
  updateSelectCount()
  $(".rck").change ->
    processClick(this)

# ----- Pressing Clear Buttons -----

window.clearAll = ->
  $('.rck').prop("checked", false).checkboxradio("refresh")
  $('.sbx').prop("checked", false).checkboxradio("refresh")
  updateSelectCount()

window.clearOOT = ->
  $('.unavailable').prop("checked", false).checkboxradio("refresh")
  updateSelectCount()

$(document).ready ->
  $('.clear_all').click -> clearAll()
  $('.clear_oot').click -> clearOOT()

# ----- Toggling Select Buttons -----

setBtns = (typ, state) ->
  $(".b_#{typ}").prop('checked', state).checkboxradio("refresh")
  $(".#{typ}").prop('checked', state).checkboxradio("refresh")
  updateSelectCount()

window.toggleTm = (box) -> setBtns("TM", $(box).is(':checked'))
window.toggleFm = (box) -> setBtns("FM", $(box).is(':checked'))
window.toggleT  = (box) -> setBtns("T",  $(box).is(':checked'))

$(document).ready ->
  $('.b_TM').change -> toggleTm(this)
  $('.b_FM').change -> toggleFm(this)
  $('.b_T').change ->  toggleT(this)

# ----- Update Remaining Characters -----

# berg-taylor is the longest name in the unit (worst case)
headerCount = ->
  "Subject: BAMRU [berg-taylor_xxxx] ".length

messageCount = ->
  $("#textarea").val().length

nameCount = ->
  " (from #{PREVIEW_OPTS.name})".length

rsvpCount = ->
  attr = $('#rsvp_select').attr('value')
  return 0 if attr == ''
  return 0 if attr == undefined
  JSON.parse(attr).prompt.length + 1


updateTextBoxCount = ->
  remain = 136 - headerCount() - messageCount() - nameCount() - rsvpCount()
  out_txt = if remain >= 30 then "" else " (#{remain} characters left)"
  $("#chars_remaining").text(out_txt)

$(document).ready ->
  updateTextBoxCount()
  $("#textarea").keyup     -> updateTextBoxCount()
  $("#rsvp_select").change -> updateTextBoxCount()