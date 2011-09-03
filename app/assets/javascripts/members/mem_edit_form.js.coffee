###
This is code to support the members/edit form.
###

window.set_field_icons = (field_id) ->
  selector = '#' + field_id
  count = $(selector).children("li:visible").size()
  if count == 1
    $("#{selector} .span_handle").removeClass('sort_handle')
    $("#{selector} .handle").attr('src', '/images/gray_handle.png')
  else
    $("#{selector} .span_handle").addClass('sort_handle')
    $("#{selector} .handle").attr('src', '/images/handle.png')

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

# called when 'add' is clicked on the members/edit form
window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  # cleanup the escaped string delivered by rails
  str    = content.replace(regexp, new_id)
  cleanStr = cleanup(str)
  # find the parent div
  tgtDiv = $(link).parent().next()
  divLen = tgtDiv.children("li").length
  if divLen == 0  # if the target div is empty, just drop in the new string
    tgtDiv.html(cleanStr)
  else # otherwise put it after the last child...
    tgtDiv.children().last().after(cleanStr)
  length = tgtDiv.children("li").length
  lastLi = tgtDiv.children("li").last()
  # set the sort attribute on the newly inserted element
  tgtInput = lastLi.children("input").first()
  tgtInput.attr("value", length)
  # set the icons
  console.log tgtDiv.attr('id')
  set_field_icons(tgtDiv.attr('id'))
  # highlight the inserted element
  lastLi.effect("shake", {times:1}, 250)
  lastLi.effect("highlight", {}, 1000)
  # set an auto-erase callback on all input and textarea elements
  $("input, textarea").focus ->    # erase the input value if it contains three dots...
    ele = $(this)
    ele.prop("value", "") if ele.prop("value").search(/\.\.\./) != -1
  equalHeight("#x_right_col",   "#x_left_col")
  equalHeight("#mem_right_col", "#mem_left_col")
  $('.phone_box').click -> mem_show_popup(this, "#phone_popup")
  $('.email_box').click -> mem_show_popup(this, "#email_popup")

# called when 'remove' is clicked on the members/edit form
window.remove_fields = (link) ->
  answer = confirm("Are you sure?")
  if answer
    $(link).next("input[type=hidden]").val("1")
    $(link).closest(".fields").hide()
    $("#x_right_col").height("100%")
    $("#mem_right_col").height("100%")
    equalHeight("#x_right_col",   "#x_left_col")
    equalHeight("#mem_right_col", "#mem_left_col")
    tgtDiv = $(link).parent().parent().attr('id')
    set_field_icons(tgtDiv)

$(document).ready ->
  set_field_icons 'sortable_phones'
  set_field_icons 'sortable_emails'
  set_field_icons 'sortable_addresses'
  set_field_icons 'sortable_emergency_contacts'
  set_field_icons 'sortable_other_infos'
  set_field_icons 'sortable_photos'

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()