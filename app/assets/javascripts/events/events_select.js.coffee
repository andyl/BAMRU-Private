trShow = (typ) -> $(".tr-#{typ}").show()
trHide = (typ) -> $(".tr-#{typ}").hide()

bType = (box) -> box.id.split('-')[1]

toggleBox = (box) ->
  box_type = bType(box)
  if $(box).is(':checked')
    trShow(box_type)
  else
    trHide(box_type)
  box.blur()

checkAll = -> $('.cksel').prop("checked", true)

$(document).ready ->
  $(".cksel").click -> toggleBox(this)
  checkAll()