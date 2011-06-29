# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $(".alt_name").hide()
  $(".namepick").change ->
    value = $(this).prop("value")
    id = $(this).attr("data_handle")
    if value == "<other name>"
      $("[data_handle='#{id}']").val("")
      $('#' + id).show()
    else
      $('#' + id).hide()

$(document).ready ->
  $(".xupdate").click ->
    inp = $(this).prev()
    val = inp.prop("value")
    inp.prop("value", "")
    id  = $(this).attr("data_button")
    $('#' + id).hide()
    $("[data_handle='#{id}']").children().last().before("<option value='#{val}'>#{val}</option>")
    $("[data_handle='#{id}']").val(val)