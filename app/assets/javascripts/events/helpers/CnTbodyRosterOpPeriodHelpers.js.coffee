BB.Helpers.CnTbodyRosterOpPeriodHelpers =
  deletePeriodLink: (periodId) ->
    "<a href='#' class='deletePeriod' data-id='#{periodId}'>X</a>"

  # ----- guestLink or RSVP link -----

  actionLink: ->
    event = BB.Collections.events.get(@event_id)
    if event.get('typ') == "training"
      @guestLink()
    else
      @rsvpLink()
  guestLink: ->
      "<a style='margin-right: 40px;' style='display: none;' href='#' class='createGuestLink' id='createGuestLink#{@id}'>add new guest</a>"
  rsvpLink: ->
      "<input style='margin-right: 40px;' type='button' class='rsvpLink' value='link to rsvp'/>"

  # ----- add participants -----

  memberField: ->
    if @isActive
      "<input style='margin-left: 80px;' size=18 class='memberField' id='memberField#{@id}' name='newParticipant' placeholder='add participant...' />"
    else
      "<a style='margin-left: 60px;' href='#' class='addParticipant'>add participant</a>"

  titleField: ->
    string = "Period #{@position}"
    if @isActive
      "<b style='margin-left: 10px;'>#{string}</b>"
    else
      "<a style='margin-left: 10px;' href='#' class='selectPeriod'>#{string}</a>"

  pdfField: ->
    "
    <div style='display: inline-block; padding-left: 30px;'> </div>
    <a id='pdfLink#{@id}' style='display: none; font-size: 7pt;' href='/reports/#{@id}/DO-field.pdf' target='_blank'>pdf</a>
    "

  timeHeaders: ->
    displayState = BB.UI.rosterState.get('showTimes')
    switch displayState
      when "none"    then ""
      when 'transit' then "<th>En-route at</th><th>Return at</th>"
      when "signin"  then "<th>Sign-in at</th><th>Sign-out at</th>"
      else ""

  minMax: ->
    displayState = BB.UI.rosterState.get("#{@id}")
    if displayState == "min"
      "<a href='#' class='maxWin'>></a>"
    else
      "<a href='#' class='minWin'>v</a>"

  showTable: ->
    BB.UI.rosterState.get("#{@id}") != "min"
