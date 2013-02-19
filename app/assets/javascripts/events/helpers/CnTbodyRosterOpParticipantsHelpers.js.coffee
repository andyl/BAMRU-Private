BB.Helpers.CnTbodyRosterOpParticipantsHelpers =

  memberStats: ->
    numParts = @participants.numMembers()
    if numParts > 0
      vals1 = "TM FM T R S A G".split(' ').map((typ) => [typ, @participants.memTyp(typ).length])
      vals2 = _.filter(vals1, (pair) -> pair[1] != 0)
      vals3 = vals2.map((pair) -> pair.join(':')).join(' ')
      partWord = if numParts > 1 then "participants" else "participant"
      "<div style='font-size: 7pt; padding-left: 8px;'>#{numParts} #{partWord} (#{vals3})</div>"

  timeHeaders: ->
    displayState = BB.UI.rosterState.get('showTimes')
    switch displayState
      when "none"    then ""
      when 'transit' then "<th>En-route at #{@departureQueryLink()}</th><th>Return at  #{@returnQueryLink()}</th>"
      when "signin"  then "<th>Sign-in at</th><th>Sign-out at</th>"
      else ""

  departureQueryLink: ->
    if @participants.numPendingDeparture() > 0
      path = "/members?format=leave&period=#{@id}"
      "<a style='padding-left:5px;font-size:7pt;' href='#{path}' target=_blank>query></a>"
    else
      ""

  returnQueryLink: ->
    if @participants.numPendingReturn() > 0
      path = "/members?format=return&period=#{@id}"
      "<a style='padding-left:5px;font-size:7pt;' href='#{path}' target=_blank>query></a>"
    else
      ""

  infoLink: ->
    if @participants.length > 0
      path = "/members?format=all&period=#{@id}"
      "<a style='padding-left:5px;font-size:7pt;' href='#{path}' target=_blank>info></a>"
    else
      ""
