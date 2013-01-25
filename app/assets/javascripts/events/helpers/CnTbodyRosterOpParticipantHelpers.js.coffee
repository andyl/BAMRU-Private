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
    startNow  = " <a class='startNow'  data-id='#{partId}' href='#'>N</a>"
    finishNow = " <a class='finishNow' data-id='#{partId}' href='#'>N</a>"
    startAll =  " <a class='startAll'  data-id='#{partId}' href='#'>$</a>"
    finishAll = " <a class='finishAll' data-id='#{partId}' href='#'>$</a>"
    startCMD   = if typKlas == 'transitPick' then startNow else startAll
    finishCMD  = if typKlas == 'transitPick' then finishNow else finishAll
    startHTML  = htmlField(startStr, startTag) + startCMD
    finishHTML = if startStr == "" then "" else htmlField(finishStr, finishTag) + finishCMD
    "<td>#{startHTML}</td><td>#{finishHTML}</td>"

  updatedAt: ->
    moment(@updated_at, "YYYY-MM-DD HH:mm").strftime("%m-%d %H:%M")

_.extend(BB.Helpers.CnTbodyRosterOpParticipantHelpers, BB.Helpers.ParticipantHelpers)
