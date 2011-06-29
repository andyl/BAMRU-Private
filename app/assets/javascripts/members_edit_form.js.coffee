###
This is code to support the members/edit form.
###

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

window.gettID = (content) ->
  start_index = content.indexOf("id=") + 3
  end_index   = content.indexOf(">\n")
  content.substring(start_index, end_index)

# called when 'add' is clicked on the members/edit form
window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  str    = content.replace(regexp, new_id)
  cleanStr = cleanup(str)
  strID  = gettID(cleanStr)
  tgtDiv = $(link).parent().next()
  divLen = tgtDiv.children("li").length
  if divLen == 0
    tgtDiv.html(cleanStr)
  else
    tgtDiv.children().last().after(cleanStr)
  length = tgtDiv.children("li").length
  lastLi = tgtDiv.children("li").last()
  tgtInput = lastLi.children("input").first()
  tgtInput.attr("value", length)
  $("#" + strID).effect("shake", {times:1}, 300)
  $("#" + strID).effect("highlight", {}, 1000)
  $("input").focus ->    # erase the input value if it contains three dots...
    ele = $(this)
    ele.prop("value", "") if ele.prop("value").search(/\.\.\./) != -1

# called when 'remove' is clicked on the members/edit form
window.remove_fields = (link) ->
  $(link).next("input[type=hidden]").val("1")
  $(link).closest(".fields").hide()

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()