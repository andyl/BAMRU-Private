BB.Helpers.CnTbodyRosterOpParticipantsHelpers =

  participantLink: ->
    numParts = @participants.length
    console.log "NP", numParts, @participants
    if numParts > 0 then " (#{numParts})" else ""

  timeHeaders: ->
    displayState = BB.UI.rosterState.get('showTimes')
    switch displayState
      when "none"    then ""
      when 'transit' then "<th>En-route at</th><th>Return at</th>"
      when "signin"  then "<th>Sign-in at</th><th>Sign-out at</th>"
      else ""
