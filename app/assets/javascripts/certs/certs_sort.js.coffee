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
    cursor:      'crosshair'
    update: ->
      data = $(target).sortable('serialize')
      console.log data
      $.ajax
        type: 'post'
        url:  "/members/#{MEMBER_ID}/certs/sort"
        data: data
        dataType: 'script'

$(document).ready ->
  setup_sort("#sortable_medical_certs")
  setup_sort("#sortable_cpr_certs")
  setup_sort("#sortable_ham_certs")
  setup_sort("#sortable_tracking_certs")
  setup_sort("#sortable_avalanche_certs")
  setup_sort("#sortable_rigging_certs")
  setup_sort("#sortable_ics_certs")
  setup_sort("#sortable_overhead_certs")
  setup_sort("#sortable_driver_certs")
  setup_sort("#sortable_background_certs")

