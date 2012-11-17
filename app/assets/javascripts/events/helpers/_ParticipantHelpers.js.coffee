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


  memberLink: (memberId) ->
    member = BB.members.get(memberId)
    "<a href='/members/#{memberId}'>#{member.fullName()}</a>"

  memberCell: (memberId) ->
    "<td#{@activeClass()}>#{@memberLink(memberId)}</td>"

  activeClass: ->
    return " class='pubSubdEvent'"   if @pubSub?
    return " class='newMember'"      if @newMember?
    return " class='matchMember'"    if @matchMember?
    return ""
