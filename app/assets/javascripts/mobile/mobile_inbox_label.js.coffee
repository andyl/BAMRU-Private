# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  console.log 'loading'
  $('.no-cache').live 'pageshow', ->
    console.log "working"
    $.get '/mobile/unread', (label) ->
      console.log "New label is: #{label}"
      $('#inbox-label').text(label)
