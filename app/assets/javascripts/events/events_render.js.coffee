# ----- setup sidebar highlight and border title -----

sidebarHighLight = ->
  evId    = $('#tabs').data('eventid')
  evTitle = $('#tabs').data('title')
  $('.edtd').css 'background', 'white'
  if evTitle
    evTag = "#ed-#{evId}"
    $(evTag).css 'background', 'yellow'
    $("#header_right").text evTitle

updateEventHeaderNav = ->
  $('#event_link').html('<a href="/events">Events</a>')

setupPjaxListener = ->
  $('.ev-pjax').pjax('[data-pjax-container]')

window.renderSidebar = ->
  $.get '/events_sidebar', (data, status, obj) ->
    $('#ui-table').html(data)
    $('#ui-table').trigger('sidebar:refresh')
    setupPjaxListener()

# ----- initialize -----

$(document).ready ->
  if $('#ui-table').html().length == 7
    renderSidebar()

$(document).on 'sidebar:refresh', -> sidebarHighLight()
$(document).on "pjax:end",        ->
  sidebarHighLight()
  updateEventHeaderNav()