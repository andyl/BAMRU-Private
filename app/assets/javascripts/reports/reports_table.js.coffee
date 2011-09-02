###
This is jQuery code that manages the
table sorting on the reports/index page.

Table sorter plugin at: http://tablesorter.com
###

headers =
  headers:
    3: {sorter: false}

$(document).ready ->
  $("#myTable").tablesorter headers