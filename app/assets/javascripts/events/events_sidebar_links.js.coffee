# ----- hide/show search -----

hideSearchDiv = ->
  $('#toggle_link').text("show")
  $('#search_div').hide()

showSearchDiv = ->
  $('#toggle_link').text("hide")
  $('#search_div').show()

toggleSearchDiv = ->
  if $('#toggle_link').text() == "hide"
    hideSearchDiv()
  else
    showSearchDiv()
  $('#toggle_link').blur()

setupBackgroundColors = ->
  $('#toggle_link').mouseenter ->
    $(this).css 'background', 'lightgrey'
  $('#toggle_link').mouseleave ->
    $(this).css 'background', 'white'

setupSearchDiv = ->
  $('#toggle_link').click -> toggleSearchDiv()

# ----- change date range -----

rangeChange = ->
  createCookie("start",  $('select[name="start"]').val(),  45)
  createCookie("finish", $('select[name="finish"]').val(), 45)
  renderSidebar()

# ----- reset search -----

setupReset = ->
  $('#date-change').click ->
    rangeChange()
  $('#reset_search').click ->
    eraseCookie("start")
    eraseCookie("finish")
    eraseCookie("event_sort")
    renderSidebar()

# ----- create new event -----


# ----- initialize -----

$(document).on 'sidebar:refresh', ->
  setupBackgroundColors()
  setupSearchDiv()
  setupReset()

