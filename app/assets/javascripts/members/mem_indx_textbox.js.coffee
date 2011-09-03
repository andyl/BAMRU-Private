###
This file has one jQuery functions:
- update the number of characters left in the text box
###

updateTextBoxCount = ->
  remain = 132 - $("#message_area").val().length
  $("#chars_remaining").text(remain)


# update the number of characters left in the text box (max 132)
$(document).ready ->
  updateTextBoxCount()
  $("#message_area").keyup ->
    updateTextBoxCount()
