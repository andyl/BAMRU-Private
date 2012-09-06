# ----- hide/show search -----

hideSearch = ->
  $('#search_link').text("show")
  $('#search_div').hide()

showSearch = ->
  $('#search_link').text("hide")
  $('#search_div').show()

toggleSearch = ->
  if $('#search_link').text() == "hide"
    hideSearch()
  else
    showSearch()

setupSearch = ->
  $('#search_link').click -> toggleSearch()

# ----- hide/show legend -----

hideLegend = ->
  $('#legend_link').text("legend")
  $('#legend_div').hide()

showLegend = ->
  $('#legend_link').text("legend [x]")
  $('#legend_div').show()

toggleLegend = ->
  if $('#legend_link').text() == "legend"
    showLegend()
  else
    hideLegend()

setupLegend = ->
  $('#legend_div').hide()
  $('#legend_link').click -> toggleLegend()


# ----- reset search -----


# ----- create new event -----



# ----- initialize -----

$(document).ready ->
  setupSearch()
  setupLegend()