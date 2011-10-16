window.blank = (item) ->
  item == "" || item == undefined

$(window).bind "pageinit", (obj) ->
  page = obj.currentTarget.hash
  if page == "#roster"
    miv = new MembersIndexView
    miv.render()
  if page == "#message-log"
    miv = new MessagesIndexView
    miv.render()
  if page == "#inbox"
    miv = new DistributionsIndexView
    miv.render()

$(window).bind "pagebeforeshow", (obj) ->
  page = obj.currentTarget.hash
  console.log page
  if page == "#member"
    obj.preventDefault()
    id = localStorage['memid']
    unless blank(id)
      member = members.get(id)
      view = new MemberShowView({model: member})
      $('#member_show').html(view.render().el)
      view.generate_page_elements()
  if page == "#message"
    id = localStorage['msgid']
    unless blank(id)
      message = messages.get(id)
      view = new MessageShowView({model: message})
      $('#message_show').html(view.render().el)
