BB.Helpers.CnTbodyRosterOpPeriodHelpers =
  deletePeriodLink: (periodId) ->
    "[<a href='#' class='deletePeriod' data-id='#{periodId}'>X</a>]"
  actionLink: ->
    event = BB.Collections.events.get(@event_id)
    if event.get('typ') == "training"
      @guestLink()
    else
      @rsvpLink()
  guestLink: ->
      "<a style='margin-left: 20px;' style='display: none;' href='#' class='createGuestLink' id='createGuestLink#{@id}'>add new guest</a>"
  rsvpLink: ->
      "<input type='button' style='margin-left: 40px;' class='rsvpLink' value='link to rsvp'/>"
