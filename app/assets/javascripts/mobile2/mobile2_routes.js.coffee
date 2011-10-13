blank = (item) ->
  item == "" || item == undefined

$(window).bind "pageinit", (obj) ->
  page = obj.currentTarget.hash
  if page == "#roster"
    miv = new MembersIndexView
    miv.render()
  if page == "#message-log"
    miv = new MessagesIndexView
    miv.render()

$(window).bind "pagebeforeshow", (obj) ->
  page = obj.currentTarget.hash
  if page == "#member"
    id = localStorage['memID']
    unless blank(id)
      member = members.get(id)
      view = new MemberShowView({model: member})
      $('#member_show').html(view.render().el)
      view.generate_page_elements()
  if page == "#message"
    id = localStorage['msgID']
    unless blank(id)
      message = messages.get(id)
      view = new MessageShowView({model: message})
      $('#message_show').html(view.render().el)
