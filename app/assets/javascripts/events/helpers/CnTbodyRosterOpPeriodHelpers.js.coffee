BB.Helpers.CnTbodyRosterOpPeriodHelpers =
  deletePeriodLink: (periodId) ->
    ttip = "data-ttip='Delete period'"
    "<a href='#' #{ttip} class='deletePeriod' data-id='#{periodId}'>X</a>"

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

  isActive: ->
    pId = BB.UI.rosterState.get('active')
    pId == @id

  memberField: ->
    if @isActive()
      "<input style='margin-left: 40px;' size=14 class='memberField' id='memberField#{@id}' name='newParticipant' placeholder='add participant...' />"
    else
      "<a style='margin-left: 40px;' href='#' class='addParticipant'>add participant</a>"

  titleField: ->
    string = "Period #{@position}"
    if @isActive()
      "<b style='margin-left: 10px;'>#{string}</b>"
    else
      "<a style='margin-left: 10px;' href='#' class='selectPeriod'>#{string}</a>"

  pdfField: ->
    ttip = "data-ttip='Generate printable roster'"
    href = "href='/reports/#{@id}/DO-field.pdf'"
    "
    <div style='display: inline-block; padding-left: 15px;'> </div>
    <a id='pdfLink#{@id}' #{ttip} #{href} style='display: none; font-size: 7pt;' target='_blank'>pdf</a>
    <div style='display: inline-block; padding-right: 5px;'> </div>
    "

  inviteField: ->
    ttip = "data-ttip='Create unit-wide RSVP'"
    href = "href='/members?format=invite&period=#{@id}'"
    "
    <a style='font-size: 7pt;' #{ttip} #{href} target='_blank'>invite></a>
    "

  broadcastField: ->
    ttip = "data-ttip='Create unit-wide message'"
    href = "href='/members?format=broadcast&period=#{@id}'"
    "
    <a style='font-size: 7pt;' #{ttip} #{href} target='_blank'>broadcast></a>
    "

  minMax: ->
    displayState = BB.UI.rosterState.get("#{@id}")
    if displayState == "min"
      ttip="data-ttip='Maximize'"
      "<a href='#' #{ttip} class='maxWin'>></a>"
    else
      ttip="data-ttip='Minimize'"
      "<a href='#' #{ttip} class='minWin'>v</a>"

  showTable: ->
    BB.UI.rosterState.get("#{@id}") != "min"
