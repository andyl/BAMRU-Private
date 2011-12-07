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
  $('.select_count').text(txt)
  mem_txt = if count == 0 then "0" else "#{count}"
  word    = if count == 1 then "member" else "members"
  $('#pgr_submit').text("Send to #{mem_txt} #{word}")

$(document).ready ->
  updateSelectCount()
  $(".rck").click ->
    updateSelectCount()

# ----- Pressing Clear Buttons -----

window.clearAll = ->
  $('.rck').each -> @.checked = false
  $('.sbx').each -> @.checked = false
  updateSelectCount()
  false

window.clearOOT = ->
  $('.unavailable').each -> @.checked = false
  updateSelectCount()
  false

$(document).ready ->
  $('.clear_all').click -> clearAll()
  $('.clear_oot').click -> clearOOT()

# ----- Toggling Select Buttons -----

setBtns = (typ, state) ->
  $(".#{typ}").each -> @.checked = state
  updateSelectCount()
  false

window.toggleTm = (box) -> setBtns("TM", $(box).is(':checked'))
window.toggleFm = (box) -> setBtns("FM", $(box).is(':checked'))
window.toggleT  = (box) -> setBtns("T",  $(box).is(':checked'))

$(document).ready ->
  $('#tm_ck').change -> toggleTm(this)
  $('#fm_ck').change -> toggleFm(this)
  $('#t_ck').change ->  toggleT(this)

# ----- Update Remaining Characters -----

# berg-taylor is the longest name in the unit (worst case)
headerCount = ->
  "Subject: BAMRU [berg-taylor_xxxx] ".length

messageCount = ->
  $("#textarea").val().length

nameCount = ->
  " (from A. Name)".length

rsvpCount = ->
  attr = $('#rsvp_select').attr('value')
  return 0 if attr == ''
  return 0 if attr == undefined
  JSON.parse(attr).prompt.length + 1


updateTextBoxCount = ->
  remain = 136 - headerCount() - messageCount() - nameCount() - rsvpCount()
  out_txt = if remain >= 30 then "" else " (#{remain} characters left)"
  $("#chars_remaining").text(out_txt)

#$(document).ready ->
#  updateTextBoxCount()
#  $("#textarea").keyup     -> updateTextBoxCount()
#  $("#rsvp_select").change -> updateTextBoxCount()