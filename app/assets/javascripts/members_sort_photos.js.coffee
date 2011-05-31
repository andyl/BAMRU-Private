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
      url = "/members/#{MEMBER_ID}/photos/sort"
      $.ajax
        type: 'post'
        url:  url
        data: $("#sortable").sortable('serialize')
        dataType: 'script'
  $("#sortable").disableSelection()
