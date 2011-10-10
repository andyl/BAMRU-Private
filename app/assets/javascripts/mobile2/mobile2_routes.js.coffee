# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

# ----- Adds a label on the home page to show online/offline status -----
console.log "IN ROUTES"

$(window).bind "pagebeforeshow", (obj) -> console.log(obj.currentTarget.hash)
