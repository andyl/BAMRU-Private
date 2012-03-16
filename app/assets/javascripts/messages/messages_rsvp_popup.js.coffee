###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

window.left_position = (type) ->
  screen_width   = $(window).width()
  popup_width_s  = $(type).css("width").split("p",1)
  popup_width_i  = parseInt(popup_width_s)
  halfw = Math.floor(screen_width / 2)
  halfp = Math.floor(popup_width_i / 2)
  halfw - halfp + 120

window.setupRSVP = (link) ->
  name   = $(link).attr('data-name')
  value  = $(link).html()
  linkid = $(link).attr('id')
  rsvpid = $(link).attr('data-rsvpid')
  msgid  = $(link).attr('data-msgid')
  console.log "rsvpid", rsvpid
  $('#yes_link').attr('data-linkid', linkid)
  $('#yes_link').attr('data-msgid',  msgid)
  $('#yes_link').attr('data-rsvpid', rsvpid)
  $('#no_link').attr('data-linkid', linkid)
  $('#no_link').attr('data-msgid',  msgid)
  $('#no_link').attr('data-rsvpid', rsvpid)
  $('#member_name').html(name)
  $('#current_response').html(value.toUpperCase())
  $('.yes_response').show()
  $('.no_response').show()
  switch value
    when 'yes' then $('.yes_response').hide()
    when 'no' then $('.no_response').hide()

window.changeRSVP = (el, value)->
  console.log el
  rsvpid = $(el).attr('data-rsvpid')
  msgid  = $(el).attr('data-msgid')
  $.get("/rsvps/#{rsvpid}?response=#{value}")
  newurl = "/messages/#{msgid}/update_rsvp?rsvpid=#{rsvpid}&value=#{value}"
  window.location.href = newurl

window.msgShowPopup = (link, type) ->
  setupRSVP(link)
  $(type).css("left", left_position(type))
  $('#blanket').fadeIn('fast')
  $(type).fadeIn('fast')

window.msgClosePopup = ->
  $('#rsvp_popup').fadeOut('fast')
  $('#blanket').fadeOut('fast')

$(document).ready ->
  $('.rsvp_link').click -> msgShowPopup(this, "#rsvp_popup")
  $('#yes_link').click -> changeRSVP(this, "yes")
  $('#no_link').click -> changeRSVP(this, "no")
