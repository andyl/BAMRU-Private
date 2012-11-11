BB.Helpers.CnTbodyRosterOpParticipantHelpers =
  timeFields: ->
    displayState = BB.rosterState.get('state')
    switch displayState
      when 'none'    then ""
      when 'transit' then @transitTimeFields()
      when 'signin'  then @checkinTimeFields()
      else ""

  transitTimeFields: ->
    partId     = @id
    datePrep   = (date) ->
      if date? then moment(date, "YYYY-MM-DD HH:mm").strftime("%Y-%m-%d %H:%M") else ""
    inputTag   = (dString, dStyle) ->
      "<input class='datePick' style='font-size: 8pt;' type='text' id='#{dStyle}#{partId}' value='#{dString}' size=14>"
    enRouteStr = datePrep(@en_route_at)
    returnStr  = datePrep(@return_home_at)
    enRouteTag = inputTag(enRouteStr, 'enroute')
    returnTag  = if enRouteStr == "" then "" else inputTag(returnStr, 'return')
    "<td>#{enRouteTag}</td><td>#{returnTag}</td>"

  checkinTimeFields: ->
    partId     = @id
    datePrep   = (date) ->
      if date? then moment(date, "YYYY-MM-DD HH:mm").strftime("%Y-%m-%d %H:%M") else ""
    inputTag   = (dString, dStyle) ->
      "<input class='datePick' style='font-size: 8pt;' type='text' id='#{dStyle}#{partId}' value='#{dString}' size=14>"
    checkedInStr  = datePrep(@checked_in_at)
    checkedOutStr = datePrep(@checked_out_at)
    checkedInTag  = inputTag(checkedInStr, 'checkedIn')
    checkedOutTag = if checkedInStr == "" then "" else inputTag(checkedOutStr, 'checkedOut')
    "<td>#{checkedInTag}</td><td>#{checkedOutTag}</td>"

  updatedAt: ->
    moment(@updated_at, "YYYY-MM-DD HH:mm").strftime("%m-%d %H:%M")

_.extend(BB.Helpers.CnTbodyRosterOpParticipantHelpers, BB.Helpers.ParticipantHelpers)
