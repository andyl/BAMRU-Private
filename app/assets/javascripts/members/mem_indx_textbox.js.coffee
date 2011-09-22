###
This file has one jQuery functions:
- update the number of characters left in the text box
###

headerCount = ->
  "Subject: BAMRU PAGE [#{PREVIEW_OPTS.author_last_name}_xxxx] ".length

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
