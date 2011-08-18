###
This is jQuery code that manages the
table sorting on the unit_certs/index page.

Table sorter plugin at: http://tablesorter.com
###

headers =
  headers:
    5: { sorter: false }

filter_params =
  filterContainer:      "#filter-box"
  filterClearContainer: "#filter-clear-button"
  filterColumns:        [0,1,2]

$(document).ready ->
  $("#MyTable").tablesorter(headers)
  $("#MyTable").tablesorterFilter(filter_params)
  $("#filter-box").focus()
