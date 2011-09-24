###
This file has one jQuery functions:
- update the number of characters left in the text box
###

# berg-taylor is the longest name in the unit (worst case)
headerCount = ->
  "Subject: BAMRU [berg-taylor_xxxx] ".length

messageCount = ->
  $("#message_area").val().length

nameCount = ->
  " (from #{PREVIEW_OPTS.author_last_name})".length

window.rsvpCount = ->
  attr = $('#rsvp_value').attr('value')
  return 0 if attr == undefined
  JSON.parse(attr).prompt.length + 1

window.updateTextBoxCount = ->
  remain = 136 - headerCount() - messageCount() - nameCount() - rsvpCount()
  $("#chars_remaining").text(remain)

# update the number of characters left in the text box (max 132)
$(document).ready ->
  updateTextBoxCount()
  $("#message_area").keyup -> updateTextBoxCount()
