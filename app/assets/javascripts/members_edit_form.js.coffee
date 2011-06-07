###
This is code to support the members/edit form.
###

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

window.add_fields = (link, association, content) ->
  new_id = new Date().getTime();
  regexp = new RegExp("new_" + association, "g")
  str = content.replace(regexp, new_id)
  $(link).parent().next().after(cleanup(content.replace(regexp, new_id)))

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()