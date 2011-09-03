# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

# this code is to implement the 'pull down description' feature...
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

# this code checks to see that a Cert File -OR- a Comment has been added before updating a cert
$(document).ready ->
  $('.cert_error').hide()
  $('#save_link').click ->
    comment   = $('#cert_comment').attr('value')
    file      = $('#cert_cert').attr('value')
    unchecked = $('#check_del:not(:checked)').size() != 1
    if (comment == "") && (file == "") && unchecked
      $('.cert_error').show()
      setTimeout("$('.cert_error').hide()", 8000)
    else
      $('form').submit()
