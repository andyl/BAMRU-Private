###
for member / show
waits 1/4 second, then sets the columns to equal height
this seems to give the images time to render, so the
column heights are correct.
###

hideBlock = (ev) ->
  hideAll()
  sel = $(ev.target).data('tgt')
  $(".xshow").show()
  setEqualHeight()

showBlock = (ev) ->
  hideAll()
  sel = $(ev.target).data('tgt')
  $("##{sel}").show()
  $(".xshow").show()
  $("##{sel}S").hide()
  $("##{sel}H").show()
  setEqualHeight()

hideAll = ->
  $('.xblok').hide()
  $('.xshow').hide()
  $('.xhide').hide()

showForm = ->
  $('#updateForm').show()
  $('#roleTag').hide()
  setEqualHeight()

hideForm = (ev) ->
#  $(ev).preventDefault()
  $('#roleTag').show()
  $('#updateForm').hide()
  setEqualHeight()

$(document).ready ->
  $(".radioblk").wrap('<div class="vertical_align">')
  setTimeout('setEqualHeight();', 250)
  $('.xhide').click (ev) -> hideBlock(ev)
  $('.xshow').click (ev) -> showBlock(ev)
  $('#cancelButton').click (ev) -> hideForm(ev)
  $('#updateLink').click -> showForm()