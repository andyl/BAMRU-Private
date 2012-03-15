# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#= require jquery_tipsy


findSelectedInCol = (weekId)->
  $("[id^='#{weekId}'].green")

weekIdFx = (cell) ->
  idString = getId(cell)
  idString.split('-')[0..2].join('-')

getId = (cell) ->
  cell.attr('id')

selectNewCell = (el)->
  new_cell = $(el)
  week_id  = weekIdFx(new_cell)
  old_cell = findSelectedInCol(week_id)
  new_cell.addClass('green')
  old_cell.removeClass('green')
  highlightUnassignedMembers()
  highlightUnscheduledWeek()
  $.post("/do_planner/#{getId(new_cell)}", {directive: 'select'})
  unless old_cell.length == 0
    $.post("/do_planner/#{getId(old_cell)}", {directive: 'unselect'})

highlightUnassignedMembers = ->
  $('.memrow').each (idx, el)->
    numGreen = $(el).find('.green').length
    numAvail = $(el).find(':contains(A)').length
    if numGreen == 0 && numAvail != 0
      $(el).find('.memlabel').addClass('blue')
    else
      $(el).find('.memlabel').removeClass('blue')

highlightUnscheduledWeek = ->
  for idx in [1..13]
    headerCell = $("#week#{idx}")
    weekId = headerCell.attr('data-weekid')
    numGreen = findSelectedInCol(weekId).length
    if numGreen == 0
      headerCell.addClass('pink')
    else
      headerCell.removeClass('pink')

tipsyCommentOptions =
  title: 'data-comments'
  opacity: 0.8
  offset: 8

tipsyWeekOptions =
  title: 'data-week'
  opacity: 1.0
  gravity: 's'

$(document).ready ->
  $('[data-comments]').tipsy(tipsyCommentOptions)
  $('[data-week]').tipsy(tipsyWeekOptions)
  $('.status').click  -> selectNewCell(@)
  highlightUnassignedMembers()
  highlightUnscheduledWeek()
