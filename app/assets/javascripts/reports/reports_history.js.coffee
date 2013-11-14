
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
  
updateActivityLink = ->
  start  = $('#activity-start').val()
  finish = $('#activity-finish').val()
  link   = "/hreports/Activity.html?start=#{start}&finish=#{finish}"
  $('#activity-link').attr('href', link)

$(document).ready ->
  $("#activity-start").datepicker({dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true})
  $("#activity-finish").datepicker({dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true})
  $("#activity-start").change  -> updateActivityLink()
  $("#activity-finish").change -> updateActivityLink()

