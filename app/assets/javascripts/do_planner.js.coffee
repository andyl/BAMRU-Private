# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.


findSelectedInCol = (weekId)->
  $("[id^='#{weekId}'].green")

weekId = (cell) ->
  getId(cell).split('-')[0..2].join('-')

getId = (cell) ->
  cell.attr('id')

selectNewCell = (el)->
  new_cell = $(el)
  week_id  = weekId(new_cell)
  old_cell = findSelectedInCol(week_id)
  new_cell.addClass('green')
  old_cell.removeClass('green')
  $.post("/do_planner/#{getId(new_cell)}", {directive: 'select'})
  unless old_cell.length == 0
    $.post("/do_planner/#{getId(old_cell)}", {directive: 'unselect'})

updateComments = (el) ->
  comments = $(el).attr('data-comments')
  $('#comment-span').html(comments)

$(document).ready ->
  $('.status').click  -> selectNewCell(@)
  $('.status').hover -> updateComments(@)
