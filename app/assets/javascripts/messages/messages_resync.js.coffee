###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

window.startMailSync = ->
  $.get("/home/silent_mail_sync")
  alert "Mail Sync has started, and takes 2-4 minutes to complete."

$(document).ready ->
  $("#resync_link").click -> startMailSync()

