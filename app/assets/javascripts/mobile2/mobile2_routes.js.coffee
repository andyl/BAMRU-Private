
window.pageInfo = (obj) ->
  hash      = obj.currentTarget.hash
  array     = if hash then obj.currentTarget.hash.split("?") else []
  page      = if array[0] then array[0] else ""
  y         = if array.length == 2 then array[1] else ""
  zid       = if y == "" then "" else y.split("=")
  id        = if zid[1] then zid[1] else ""
  [page, id]

$(window).bind "pageinit", (obj) ->
  [page, id] = pageInfo(obj)
  if page == "#roster"
    miv = new MembersIndexView
    miv.render()
  if page == "#message-log"
    miv = new MessagesIndexView
    miv.render()

$(window).bind "pagebeforeshow", (obj) ->
  [page, id] = pageInfo(obj)
  if page == "#member"
    member = members.get(id)
    view = new MemberShowView({model: member})
    $('#member_show').html(view.render().el)
    view.generate_page_elements()
  if page == "#message"
    message = messages.get(id)
    view = new MessageShowView({model: message})
    $('#message_show').html(view.render().el)
