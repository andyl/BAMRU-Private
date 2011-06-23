###
This is jQuery code that manages the
autoselect input box on the members pages.
- members/show
- members/edit

It relies on the Autoselect widget in jQuery UI.
###

autoselect_opts =
  source: autoselectMemberNames
  select: (event, ui) -> window.location.href = ui.item.url


$(document).ready ->
  $("input").focus ->    # erase the input value if it contains three dots...
    ele = $(this)
    ele.prop("value", "") if ele.prop("value").search(/\.\.\./) != -1
  $("#autoselect").autocomplete(autoselect_opts)