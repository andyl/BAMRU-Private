###
Used to sort photos (drag & drop)
Relies on jQuery UI
###
#= require equal_height

# berg-taylor is the longest name in the unit (worst case)
headerCountRepage = ->
  "Subject: BAMRU [berg-taylor_xxxx] ".length

messageCountRepage = ->
  $("#message_area").val().length

nameCountRepage = ->
  " (from #{PREVIEW_OPTS.author_last_name})".length

window.rsvpCountRepage = ->
  $('#rsvp_prompt').html().length + 1

window.updateTextBoxCountRepage = ->
  remain = 136 - headerCountRepage() - messageCountRepage() - nameCountRepage() - rsvpCountRepage()
  $("#chars_remaining").text(remain)

# update the number of characters left in the text box (max 132)
$(document).ready ->
  updateTextBoxCountRepage()
  $("#message_area").keyup -> updateTextBoxCountRepage()


window.leftPositionRepage = (type) ->
  screen_width   = $(window).width()
  popup_width_s  = $(type).css("width").split("p",1)
  popup_width_i  = parseInt(popup_width_s)
  halfw = Math.floor(screen_width / 2)
  halfp = Math.floor(popup_width_i / 2)
  halfw - halfp - 40

window.msgShowPopupRepage = (link, type) ->
  $(type).css("left", leftPositionRepage(type))
  $('#blanket').fadeIn('fast')
  $(type).fadeIn('fast')

window.msgClosePopupRepage = ->
  $('#repage_popup').fadeOut('fast')
  $('#blanket').fadeOut('fast')

submitForm = ->
  if messageCountRepage() < 5
    alert "No Message Text - Please Retry"
    return
  $('#repage_form').submit()


$(document).ready ->
  equalHeight("#y_left_col", "#y_right_col")
  $('#repage_link').click -> msgShowPopupRepage(this, "#repage_popup")
  $('#send_button').click -> submitForm()
