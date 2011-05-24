# checkbox id's are encoded as 'cb_TM' or 'cb_FM'
# the boxType is the part after the underscore...
boxType = (box) -> box.id.split('_')[1]

enCheck = (box) -> $(".#{boxType(box)}").prop("checked", true)
deCheck = (box) -> $(".#{boxType(box)}").prop("checked", false)

toggleClick = (box) ->
  if $(box).is(':checked') then enCheck(box) else deCheck(box)

$(document).ready -> $(".slx").click -> toggleClick(this)