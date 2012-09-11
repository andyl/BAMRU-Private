###
Relies on jQuery_Layout
http://layout.jquery-dev.net/
###

layoutOptions =
  applyDefaultStyles: true
  west__size: 320
  west__resizable: false

setColumnHeight = ->
  tgtHeight = window.innerHeight - 170 - $('#debug_footer').height()
  $('#x_single_col').css('height', "#{tgtHeight}px")

$(document).ready ->
  setColumnHeight()
  $('#x_single_col').layout(layoutOptions)
  $('#tabs').tabs()
  $(document).on 'pjax:end', -> $('#tabs').tabs()
  window.onresize = -> setColumnHeight()


