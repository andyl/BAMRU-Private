###
managed pagable popups
###

window.left_position = (type) ->
  screen_width   = $(window).width()
  popup_width_s  = $(type).css("width").split("p",1)
  popup_width_i  = parseInt(popup_width_s)
  halfw = Math.floor(screen_width / 2)
  halfp = Math.floor(popup_width_i / 2)
  halfw - halfp

window.setup_phone = (link) ->
  number = $(link).siblings('input[id$=number]').get(0).getAttribute('value')
  sms_adr = $(link).siblings('input[id$=sms_email]').get(0).getAttribute('value')
  $('#sms_adr').attr('value', sms_adr)
  page_count = $(link).siblings('input[id$=pagable]:checked').size()
  if page_count == 1
    $('#radiop_yes').prop('checked', true)
  else
    $('#radiop_no').prop('checked', true)
  $('#phone_num').html(number)

window.setup_email = (link) ->
  address = $(link).siblings('input[id$=address]').get(0).getAttribute('value')
  page_count = $(link).siblings('input[id$=pagable]:checked').size()
  if page_count == 1
    $('#radio_yes').prop('checked', true)
  else
    $('#radio_no').prop('checked', true)
  $('#email_adr').html(address)

window.set_sms_email = ->
  address = $('#sms_adr').attr('value')
  $(tgtlink).siblings("input[id$=sms_email]").attr('value', address)

window.set_pager_on = ->
  $(tgtlink).siblings("input[id$=pagable]").attr("checked", "checked")
  $(tgtlink).removeClass("black_box")
  $(tgtlink).addClass("green_box")

window.set_pager_off = ->
  $(tgtlink).siblings("input[id$=pagable]").removeAttr("checked")
  $(tgtlink).addClass("black_box")
  $(tgtlink).removeClass("green_box")

window.mem_save_email = ->
  if $('#radio_yes:checked').size() == 1
    set_pager_on()
  else
    set_pager_off()
  mem_close_popup('#email_popup')

window.mem_save_phone = ->
  set_sms_email()
  if $('#radiop_yes:checked').size() == 1
    set_pager_on()
  else
    set_pager_off()
  mem_close_popup('#phone_popup')

window.mem_show_popup = (link, type) ->
  window.tgtlink = link
  $(type).css("left", left_position(type))
  setup_email(link) if type == "#email_popup"
  setup_phone(link) if type == "#phone_popup"
  $('#blanket').fadeIn('fast');
  $(type).fadeIn('fast');

window.mem_close_popup = (type) ->
  $(type).fadeOut('fast');
  $('#blanket').fadeOut('fast');

$(document).ready ->
  $('.phone_box').click -> mem_show_popup(this, "#phone_popup")
  $('.email_box').click -> mem_show_popup(this, "#email_popup")
