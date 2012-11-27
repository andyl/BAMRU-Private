BB.Helpers.ParticipantHelpers =
  deleteParticipantLink: (participantId) ->
    "<a href='#' class='deleteParticipant' data-id='#{participantId}'>X</a>"

  memberRoleMT: (memberId) ->
    member = BB.members.get(memberId)
    member.get('typ')

  memberRoleOP: (memberId) ->
    member = BB.members.get(memberId)
    role   = member.get('typ')
    if @ol
      "<a class='unsetOL' href='#'>OL #{role}</a>"
    else
      "<a class='setOL' href='#'>#{role}</a>"

  memberIcon: (memberId) ->
    member = BB.members.get(memberId)
    photoUrl = member.get('photo_icon')
    return "" if photoUrl.length < 5
    "<img style='height:23px;width:30px;display:block;margin:0;padding:0;' src='#{photoUrl}'/>"

  memberLink: (memberId) ->
    member = BB.members.get(memberId)
    typ  = member.get('typ')
    path = if typ[0] == 'G' then 'guests' else 'members'
    "<a href='/#{path}/#{memberId}'>#{member.fullName()}</a>"

  memberCell: (memberId) ->
    "<td style='vertical-align:bottom;' #{@activeClass()}>#{@memberLink(memberId)}</td>"

  activeClass: ->
    return " class='pubSubdEvent'"   if @pubSub?
    return " class='newMember'"      if @newMember?
    return " class='matchMember'"    if @matchMember?
    return ""
