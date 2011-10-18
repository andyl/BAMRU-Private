
window.processIgnore = (link) ->
  link_id = $(link).attr('id')
  inbd_id = link_id.split('_',2)[1]
  url  = "/history/ignore?id=#{inbd_id}"
  $.get(url)
  setTimeout("window.location.reload()", 2000)

window.processDisable = (link) ->
  link_id = $(link).attr('id')
  inbd_id = link_id.split('_',2)[1]
  url  = "/history/disable?id=#{inbd_id}"
  $.get(url)
  setTimeout("window.location.reload()", 2000)

$(document).ready ->
  $('.ignore_link').click  -> processIgnore(this)
  $('.disable_link').click -> processDisable(this)
