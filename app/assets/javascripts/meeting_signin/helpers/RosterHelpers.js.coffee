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
      pid    = participant.get('id')
      memid  = participant.get('member_id')
      member = BB.members.get(memid)
      name = "#{member.get('first_name')} #{member.get('last_name')}"
      typ  = member.get('typ')
      url  = member.get('photo_icon')
      img   = "<img data-memid='#{memid}' class='xImg' src='#{url}' />"
      photo = if url.length == 0 then "" else "<a href='#' class='mobileNav imageShow'>#{img}</a>"
      dlink = "<a href='#' data-memid='#{memid}' data-id='#{pid}' class='mobileNav navDelete'>X</a>"
      "<tr><td>#{photo}</td><td>#{typ}</td><td>#{name}</td><td>#{dlink}</td></tr>").join('')
