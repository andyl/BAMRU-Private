BB.Helpers.ParticipantHelpers =
  deleteParticipantLink: (participantId) ->
    ttip = "data-ttip='Remove participant'"
    "<a href='#' #{ttip} class='deleteParticipant' data-id='#{participantId}'>X</a>"

  memberRoleMT: (memberId) ->
    member = BB.members.get(memberId)
    member?.get('typ')

  memberRoleOP: (memberId) ->
    member = BB.members.get(memberId)
    role   = member?.get('typ') || ""
    lbl  = ""
    lbl  = "OL "  if @ol
    lbl  = "AHC " if @ahc
    ttip = "data-ttip='Set Role'"
    "<a class='setRole' #{ttip} href='#'>#{lbl}#{role}</a>"

  memberIcon: (memberId) ->
    member = BB.members.get(memberId)
    photoUrl = member?.get('photo_icon')
    return "" unless photoUrl? && photoUrl.length > 5
    "<img style='height:23px;width:23px;display:block;margin:0;padding:0;' src='#{photoUrl}'/>"

  memberLink: (memberId) ->
    member = BB.members.get(memberId)
    typ  = member?.get('typ')
    console.log "TYP is", typ, member if typ == null
    return "Unknown Member #{memberId}" unless typ? && typ != null
    path = if typ[0] == 'G' then 'guests' else 'members'
    "<a data-ttip='View contact info' href='/#{path}/#{memberId}' target='_blank'>#{member.fullName()}</a>"

  memberCell: (memberId) ->
    "<td style='vertical-align:bottom;' #{@activeClass()}>#{@memberLink(memberId)}</td>"

  currentRole: ->
    return "OL" if @ol
    return "AHC" if @ahc
    "NONE"

  currentRoleLabel: ->
    cr = @currentRole()
    return "" if cr == "NONE"
    "from #{cr} "

  roleLink: (type) ->
    crole = @currentRole()
    return "" if type == crole
    "<a href='#' class='set#{type}'>#{type}</a> | "

  popupForm: (memberId) ->
    member = BB.members.get(memberId)
    name   = member.get('last_name')
    """
       set <b>#{name}'s</b> role
       #{ @currentRoleLabel() }
       to
       #{ @roleLink "AHC"  }
       #{ @roleLink "OL"   }
       #{ @roleLink "NONE" }
       <a href='#' class='setCANCEL'>Cancel</a>
    """

  activeClass: ->
    return " class='pubSubdEvent'"   if @pubSub?
    return " class='newMember'"      if @newMember?
    return " class='matchMember'"    if @matchMember?
    return ""
