###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

window.showText = (link) ->
  lbl = $(link).attr("id").split('_',1)
  $(".mail_body").hide()
  $(".click_hide").hide()
  $(".click_view").show()
  $("##{lbl}_body").show()
  $("##{lbl}_view").hide()
  $("##{lbl}_hide").show()

window.hideText = (link) ->
  lbl = $(link).attr("id").split('_',1)
  $(".mail_body").hide()
  $("##{lbl}_view").show()
  $("##{lbl}_hide").hide()

$(document).ready ->
  $(".mail_body").hide()
  $(".click_hide").hide()
  $(".click_view").click ->
    showText(this)
  $(".click_hide").click ->
    hideText(this)


