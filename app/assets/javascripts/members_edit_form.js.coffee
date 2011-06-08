###
This is code to support the members/edit form.
###

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

window.add_fields = (link, association, content) ->
  new_id = new Date().getTime();
  regexp = new RegExp("new_" + association, "g")
  str    = content.replace(regexp, new_id)
  cleanStr = cleanup(str)
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

window.remove_fields = (link) ->
  $(link).next("input[type=hidden]").val("1")
  $(link).closest(".fields").hide()

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()