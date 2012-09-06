###
This is jQuery code that manages the
table sorting on the unit_certs/index page.

Table sorter plugin at: http://tablesorter.com
###

typScore = (type) ->
  switch type.toUpperCase()[0]
    when "M"  then -10
    when "T"  then -20
    when "O"  then -30
    when "S"  then -40

typ_score_options =
  id:     'typ_score'                             # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'numeric'                               # either text or numeric
  format: (s) -> typScore(s)                     # the sort key (typ score)

sort_opts =
  headers:
    0: {sorter: 'typ_score'}    # sort col 0 using typ_score options

saveEventSortToCookie = (sort_spec) ->
  spec_string = JSON.stringify(sort_spec)
  createCookie("event_sort", spec_string)

readEventSortFromCookie = ->
  string = readCookie("event_sort")
  if (string == null) then null else JSON.parse(string)

filterParams =
  filterContainer:      "#filter-box"
  filterClearContainer: "#filter-clear-button"
  filterColumns:        [0,1,2,3]
  columns:              ["typ", "title", "location", "start"]

setupFilter = ->
  $("#myTable").tablesorterFilter(filterParams)
  $("#filter-box").focus()
  $("#filter-box").keyup ->
    setTimeout('', 750)

setupSorter = ->
  $.tablesorter.addParser typ_score_options
  sort_spec = readEventSortFromCookie()
  sort_opts['sortList'] = sort_spec unless sort_spec == null
  $("#myTable").tablesorter(sort_opts).bind "sortEnd", (sorter) ->
    saveEventSortToCookie(sorter.target.config.sortList)

setupClearSort = ->
  $('#clearsort').click ->
    eraseCookie("avail_sort")
    refresh_url = window.location.href.split(/[?#]/, 1)
    window.location.assign(refresh_url)

$(document).ready ->
  setupSorter()
  setupFilter()
