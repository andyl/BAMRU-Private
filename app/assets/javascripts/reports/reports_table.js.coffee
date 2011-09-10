###
This is jQuery code that manages the
table sorting on the reports/index page.

Table sorter plugin at: http://tablesorter.com
###

headers =
  headers:
    4: {sorter: false}

filter_params =
  filterContainer:      "#filter-box"
  filterClearContainer: "#filter-clear-button"
  filterColumns:        [0,1,2,3]
  columns:              ["category", "name", "type", "desc"]

$(document).ready ->
  $("#myTable").tablesorter(headers)
  $("#myTable").tablesorterFilter(filter_params)
  $("#filter-box").focus()
