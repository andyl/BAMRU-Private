###
Used to sort photos.
Relies on jQuery UI
###

$(document).ready ->
  $("#sortable").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.handle'
    cursor:      'crosshair'
    update: ->
      $.ajax
        type: 'post'
        url:  "/members/#{MEMBER_ID}/photos/sort"
        data: $("#sortable").sortable('serialize')
        dataType: 'script'
        complete -> $('#sortable').effect('highlight')
  $("#sortable").disableSelection()
