###
for member / show
waits 1/4 second, then sets the columns to equal height
this seems to give the images time to render, so the
column heights are correct.
###

$(document).ready ->
  setTimeout('setEqualHeight();', 250)