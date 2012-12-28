BB.Helpers.RosterHelpers =

  rosterTitle: ->
    date      = moment(@start).strftime("%b %d")
    "<b>#{@title}<br/>#{date} @ #{@location}</b>"

  rosterShow: ->
    notReady = "<tr><td>Loading...</td></tr>"
    empty    = "<tr><td>No registered participants...</td></tr>"
    return notReady unless @participants?
    return empty    if @participants.length == 0
    @participants.map((participant) ->
      member = BB.members.get(participant.get('member_id'))
      name = "#{member.get('first_name')} #{member.get('last_name')}"
      typ  = member.get('typ')
      url  = member.get('photo_icon')
      photo = if url.length == 0 then "" else "<img src='#{url}' />"
      dlink = "<a href='#' class='navz'>X</a>"
      "<tr><td>#{photo}</td><td>#{typ}</td><td>#{name}</td><td>#{dlink}</td></tr>").join('')
