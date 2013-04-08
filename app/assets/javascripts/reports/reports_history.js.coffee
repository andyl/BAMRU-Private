
updateSummaryLink = ->
  start  = $('#summary-start').val()
  finish = $('#summary-finish').val()
  link   = "/hreports/Summary.html?start=#{start}&finish=#{finish}"
  $('#summary-link').attr('href', link)

$(document).ready ->
  $("#summary-start").datepicker({dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true})
  $("#summary-finish").datepicker({dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true})
  $("#summary-start").change  -> updateSummaryLink()
  $("#summary-finish").change -> updateSummaryLink()

