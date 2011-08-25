###
managed comment popups
###

window.show_popup = (link) ->
  screen_width   = $(window).width()
  popup_width_s  = $("#popup").css("width").split("p",1)
  popup_width_i  = parseInt(popup_width_s)
  halfw = Math.floor(screen_width / 2)
  halfp = Math.floor(popup_width_i / 2)
  left_position = halfw - halfp
  $("#popname").html(link.getAttribute("data-name"))
  $("#popcomment").html(link.getAttribute("data-comment"))
  $("#popup").css("left", left_position)
  $('#blanket').fadeIn('fast');
  $('#popup').fadeIn('fast');

window.close_popup = ->
  $('#popup').fadeOut('fast');
  $('#blanket').fadeOut('fast');

$(document).ready ->
  $('.purple_link').click -> show_popup(this)