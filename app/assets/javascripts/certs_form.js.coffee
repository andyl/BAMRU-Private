# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  new_value = '*'
  $("#new_div").hide()
  $("#cert_description").change ->
    if $(this).attr('value') == new_value
      $('#new_div').show()
    else
      $('#new_div').hide()
  $('#new_input').change ->
    opt = $('#cert_description').children('option:contains("new")')
    new_value = $('#new_input').attr('value')
    opt.attr('value', new_value)
