###
This is jQuery code that manages the
table sorting on the members/index page.

Table sorter plugin at: http://tablesorter.com
###

last_name_options =
  id:     'last_name'                             # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'text'                                  # either text or numeric
  format: (s) -> (new MemberName(s)).last_name()  # the sort key (last name)

role_score_options =
  id:     'role_score'                            # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'numeric'                               # either text or numeric
  format: (s) -> (new RoleScore(s)).score()       # the sort key (last name)

sort_opts =
  headers:
    0: {sorter: 'role_score'}    # sort col 0 using role_score options
    1: {sorter: false } 
    2: {sorter: false }
    3: {sorter: 'last_name'}     # sort col 3 using last_name options

filter_params =
  filterContainer:      "#filter-box"
  filterClearContainer: "#filter-clear-button"
  filterColumns:        [0,3]
  columns:              ["role", "name"]

save_member_sort_to_cookie = (sort_spec) ->
  spec_string = JSON.stringify(sort_spec)
  createCookie("mem_sort", spec_string)

read_member_sort_from_cookie = ->
  string = readCookie("mem_sort")
  if (string == null) then null else JSON.parse(string)

$(document).ready ->
  $.tablesorter.addParser last_name_options
  $.tablesorter.addParser role_score_options
  sort_spec = read_member_sort_from_cookie()
  sort_opts['sortList'] = sort_spec unless sort_spec == null
  $("#myTable").tablesorter(sort_opts).bind "sortEnd", (sorter) ->
    save_member_sort_to_cookie(sorter.target.config.sortList)
  $("#myTable").tablesorterFilter(filter_params)
  $("#filter-box").focus()
  $("#filter-clear-button").click ->
    setTimeout('updateAddressCount()', 50)
  $("#filter-box").keyup ->
    setTimeout('setEqualHeight()', 600)
    setTimeout('updateAddressCount()', 600)

$(document).ready ->
  $('#clearsort').click ->
    eraseCookie("mem_sort")
    refresh_url = window.location.href.split(/[?#]/, 1)
    window.location.assign(refresh_url)