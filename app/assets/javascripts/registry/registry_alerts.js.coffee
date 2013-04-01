

updateDatabaseUsingAjax = (tgt_cell) ->
  tgt = $(tgt_cell)
  tgt_id  = tgt.attr('id') 
  tgt_val = tgt.text()
  [role, event] = tgt_id.split('-')
  action = if tgt_val == "X" then "set" else "del"
  $.get("/subscription/#{action}/#{event}/#{role}")

updateDisplayValue = (tgt_cell) ->
  tgt = $(tgt_cell)
  new_val = if tgt.text() == "X" then '-' else "X"
  tgt.text(new_val)

selectClickedCell = (el) ->
  tgt_cell = el.target
  updateDisplayValue(tgt_cell)
  updateDatabaseUsingAjax(tgt_cell)

$(document).ready ->
  $('.alertCell').click (el) -> selectClickedCell(el)