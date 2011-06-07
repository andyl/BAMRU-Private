###
Used to sort photos.
Relies on jQuery UI
###

$(document).ready ->
  $("#sortable_photos").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      url = "/members/#{MEMBER_ID}/photos/sort"
      $.ajax
        type: 'post'
        url:  url
        data: $("#sortable_photos").sortable('serialize')
        dataType: 'script'
  $("#sortable_photos").disableSelection()


setInput = (index, element) ->
  tgtInput = $(element).children('input').first()
  newIdx = index + 1
  tgtInput.attr("value", newIdx)

resetIndex = (inputDiv) ->
  tgtDiv = $(inputDiv)
  tgtInputs = tgtDiv.children("li")
  tgtInputs.each((idx, ele) -> setInput(idx, ele))

$(document).ready ->
  $("#sortable_phones").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      resetIndex("#sortable_phones")
  $("#sortable_emails").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      resetIndex("#sortable_addresses")
  $("#sortable_addresses").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      resetIndex("#sortable_addresses")
  $("#sortable_emergency_contacts").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      resetIndex("#sortable_emergency_contacts")
  $("#sortable_other_infos").sortable
    placeholder: "ui-state-highlight"
    axis:        'y'
    opacity:     0.4
    handle:      '.sort_handle'
    cursor:      'crosshair'
    update: ->
      resetIndex("#sortable_other_infos")
