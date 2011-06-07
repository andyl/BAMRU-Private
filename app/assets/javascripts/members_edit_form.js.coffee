###
This is code to support the members/edit form.
###

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

window.add_fields = (link, association, content) ->
  new_id = new Date().getTime();
  regexp = new RegExp("new_" + association, "g")
  str = content.replace(regexp, new_id)
  tgtDiv = $(link).parent().next()
  tgtDiv.children().last().after(cleanup(content.replace(regexp, new_id)))
  length = tgtDiv.children("li").length
  lastLi = tgtDiv.children("li").last()
  tgtInput = lastLi.children("input").first()
  tgtInput.attr("value", length)

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()