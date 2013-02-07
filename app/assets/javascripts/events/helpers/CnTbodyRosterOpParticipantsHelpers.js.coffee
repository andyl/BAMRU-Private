BB.Helpers.CnTbodyRosterOpParticipantsHelpers =

  participantCount: ->
    numParts = @participants.numMembers()
    if numParts > 0 then " (#{numParts})" else ""

  memberStats: ->
    vals1 = "TM FM T R S A G".split(' ').map((typ) => [typ, @participants.memTyp(typ).length])
    vals2 = _.filter(vals1, (pair) -> pair[1] != 0)
    vals3 = vals2.map((pair) -> pair.join(':')).join(' ')
    "<div style='font-size: 7pt'>#{vals3}</div>"

  timeHeaders: ->
    displayState = BB.UI.rosterState.get('showTimes')
    switch displayState
      when "none"    then ""
      when 'transit' then "<th>En-route at</th><th>Return at</th>"
      when "signin"  then "<th>Sign-in at</th><th>Sign-out at</th>"
      else ""
