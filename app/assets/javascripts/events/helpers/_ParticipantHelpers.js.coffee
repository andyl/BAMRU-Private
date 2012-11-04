BB.Helpers.ParticipantHelpers =
  deleteParticipantLink: (participantId) ->
    "<a href='#' class='deleteParticipant' data-id='#{participantId}'>X</a>"

  memberRole: (memberId) ->
    member = BB.members.get(memberId)
    member.get('typ')

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
