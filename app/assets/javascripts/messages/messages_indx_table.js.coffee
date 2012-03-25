###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

last_name_options =
  id:     'last_name'                             # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'text'                                  # either text or numeric
  format: (s) -> (new MemberName(s)).last_name()  # the sort key (last name)

sort_opts =
  headers:
    1: {sorter: 'last_name'}
    0: {sorter: false}
    4: {sorter: false}
    5: {sorter: false}

$(document).ready ->
  $.tablesorter.addParser last_name_options
  $("#myTable").tablesorter(sort_opts)

minCountAlert = ->
  minStr = $('#mincount').text().split(' ')[0]
  minInt = parseInt(minStr)
  if minInt > 1
    alert("Page being sent!\n\nNote: it will take at least #{minStr} minutes to deliver all messages.")

$(document).ready ->
  minCountAlert()