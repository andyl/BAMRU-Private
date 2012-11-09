BB.Helpers.CnTbodyRosterOpHelpers =
  stateCheck: (input) ->
    if BB.rosterState.get('state') == input then "checked" else ""



