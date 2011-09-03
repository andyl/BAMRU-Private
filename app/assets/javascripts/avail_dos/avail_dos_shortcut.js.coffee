# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  $("#quickset").change ->
    value = $("#quickset").children("option:selected").attr('value')
    return if value == "*"
    mem_select = $("select[id^=mem]")
    mem_select.children("option").attr("selected", false)
    if value == "unavailable"
      mem_select.children("option[value^=un]").attr("selected", true)
    if value == "available"
      mem_select.children("option[value^=av]").attr("selected", true)
    setTimeout('$("#quickset option").attr("selected", false)', 1000)