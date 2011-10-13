###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

setup_sort = (target) ->
  $(target).sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'move'
    update: ->
      data = $(target).sortable('serialize')
      $.ajax
        type: 'post'
        url:  "/rsvp_templates/sort"
        data: data
        dataType: 'script'

$(document).ready ->
  setup_sort("#sortable_templates")

