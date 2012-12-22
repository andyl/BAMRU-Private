BB.Helpers.CnTbodyRosterOpParticipantHelpers =
  timeFields: ->
    displayState = BB.UI.rosterState.get('showTimes')
    switch displayState
      when 'none'    then ""
      when 'transit' then @transitTimeFields()
      when 'signin'  then @signinTimeFields()
      else ""

  transitTimeFields: -> @genTimeFields('transitPick', 'en_route_at', 'return_home_at')

  signinTimeFields: -> @genTimeFields('signinPick', 'signed_in_at', 'signed_out_at')

  genTimeFields: (typKlas, startTag, finishTag) ->
    partId     = @id
    datePrep   = (date) ->
      return "" if date == "" || date == null || date == undefined
      moment(date, "YYYY-MM-DD HH:mm").strftime("%Y-%m-%d %H:%M")
    htmlField  = (inVal, inTag) ->
      "<input class='#{typKlas}' style='font-size: 8pt;' type='text' id='#{inTag}#{partId}' value='#{inVal}' size=14>"
    startStr  = datePrep(@["#{startTag}"])
    finishStr = datePrep(@["#{finishTag}"])
    startHTML  = htmlField(startStr, startTag)
    finishHTML = if startStr == "" then "" else htmlField(finishStr, finishTag)
    "<td>#{startHTML}</td><td>#{finishHTML}</td>"

  updatedAt: ->
    moment(@updated_at, "YYYY-MM-DD HH:mm").strftime("%m-%d %H:%M")

_.extend(BB.Helpers.CnTbodyRosterOpParticipantHelpers, BB.Helpers.ParticipantHelpers)
