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
  $("#autoselect").focus ->
    $("#autoselect").prop("value", "")
  $("#autoselect").autocomplete(autoselect_opts)