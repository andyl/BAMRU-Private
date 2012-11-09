BB.Helpers.CnTbodyRosterOpParticipantHelpers =
  timeFields: ->
    if BB.rosterState.get('state') == 'transit'
      "<td>10-24 12:00</td><td>10-24 12:00</td>"
    else
      "<td>10-24 12:00</td><td>10-24 12:00</td>"

_.extend(BB.Helpers.CnTbodyRosterOpParticipantHelpers, BB.Helpers.ParticipantHelpers)
