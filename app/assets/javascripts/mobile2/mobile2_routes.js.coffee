window.parseUrl = (string) ->
  console.log "STARTING: #{string}"
  @reg_p = /(\#[a-z\_\-]+)/
  @reg_i = /id=([0-9]+)/
  match_p = @reg_p.exec(string)
  match_i = @reg_i.exec(string)
  page   = if (match_p != null) then match_p[1] else ""
  id     = if (match_i != null) then match_i[1] else ""
  console.log "ENDING: #{string}"
  console.log [page, id]
  [page, id]

window.pageInfo = (obj) ->
  hash      = obj.currentTarget.hash
  parseUrl(hash)

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
