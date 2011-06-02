###
This file has three jQuery functions:
1) update address count
2) select by member type
3) clear all
###

# ----- 1) update address count -----

updateAddressCount = ->
  addr_count = $(".rck:checked").length
  label = if addr_count == 1 then "address" else "addresses"
  $("#addr_count").text("#{addr_count} #{label}")

$(document).ready ->
  updateAddressCount()
  $(".rck").click -> updateAddressCount()

# ----- 2) select by member type -----

# checkbox id's are encoded as 'cb_TM' or 'cb_FM'
# the boxType is the part after the underscore...
boxType = (box) -> box.id.split('_')[1]
enCheck = (box) -> $(".#{box}").prop("checked", true)
deCheck = (box) -> $(".#{box}").prop("checked", false)
toggleClick = (box) ->
  box_type = boxType(box)
  if $(box).is(':checked') then enCheck(box_type) else deCheck(box_type)
  updateAddressCount()

$(document).ready ->
  $(".slx").click -> toggleClick(this)

# ----- 3) clear all -----

clearAll = ->
  deCheck("rck")
  deCheck("slx")
  updateAddressCount()

$(document).ready ->
  $("#clear_all").click -> clearAll()


