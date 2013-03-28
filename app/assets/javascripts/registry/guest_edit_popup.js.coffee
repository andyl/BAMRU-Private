###
managed pagable popups
###

window.leftPositionRepage = (type) ->
  screen_width   = $(window).width()
  popup_width_s  = $(type).css("width").split("p",1)
  popup_width_i  = parseInt(popup_width_s)
  halfw = Math.floor(screen_width / 2)
  halfp = Math.floor(popup_width_i / 2)
  halfw - halfp

window.setup_phone = (link) ->
  number = $(link).siblings('input[id$=number]').get(0).getAttribute('value')
  short_num = number.replace(/\-/g, "")
  sms_adr = $(link).siblings('input[id$=sms_email]').get(0).getAttribute('value')
  $('#sms_adr').attr('value', sms_adr)
  page_count = $(link).siblings('input[id$=pagable]:checked').size()
  if page_count == 1
    $('#radiop_yes').prop('checked', true)
  else
    $('#radiop_no').prop('checked', true)
  $('.ten_dig').html(short_num)
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
  unless valid_email()
    show_invalid_message()
    return
  set_sms_email()
  if $('#radiop_yes:checked').size() == 1
    set_pager_on()
  else
    set_pager_off()
  mem_close_popup('#phone_popup')

window.mem_show_popup = (link, type) ->
  window.tgtlink = link
  $(type).css("left", leftPositionRepage(type))
  setup_email(link)        if type == "#email_popup"
  validate_email_address() if type == "#phone_popup"
  hide_invalid_message()   if type == "#phone_popup"
  setup_phone(link)        if type == "#phone_popup"
  $('#blanket').fadeIn('fast')
  $(type).fadeIn('fast')

window.mem_close_popup = (type) ->
  $(type).fadeOut('fast')
  $('#blanket').fadeOut('fast')

window.blank_email = ->
  $('#sms_adr').attr('value') == ""

window.valid_email = ->
  address = $('#sms_adr').attr('value')
  enabled = if $('#radiop_yes:checked').size() == 1 then true else false
  return (! enabled) if blank_email()
  reg = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
  if address.match(reg) then true else false

window.validate_email_address = ->
  if valid_email()
    $('#inval_msg').hide()
    $('#sms_adr').css("background", "white")
  else
    $('#sms_adr').css("background","pink")

window.hide_invalid_message = ->
  $('#inval_msg').hide()

window.show_invalid_message = ->
  $('#inval_msg').show()
  setTimeout("$('#inval_msg').hide()", 4000)

$(document).ready ->
  $('.phone_box').click -> mem_show_popup(this, "#phone_popup")
  $('.email_box').click -> mem_show_popup(this, "#email_popup")
  $('#sms_adr').keyup       -> validate_email_address()
  $('.radio_enable').change -> validate_email_address()
