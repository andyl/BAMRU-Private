BB.Helpers.CnIndxHelpers =

  currentTime: -> moment().strftime("%a %Y-%b-%d @ %H:%M")

  reGenEventList: ->
    @eventList = BB.Collections.events.select (event) => @isInRange(event)

  events: -> BB.Collections.events

  numEvents: (type) ->
    events = BB.Collections.events
    return events.length if type == "all"
    
  numMeetings:    -> BB.Collections.events.getMeetings().length
  numTrainings:   -> BB.Collections.events.getTrainings().length
  numOperations:  -> BB.Collections.events.getOperations().length
  numCommunity:   -> BB.Collections.events.getCommunity().length
  numSocial:      -> BB.Collections.events.getSocial().length
  numPublished:   -> BB.Collections.events.getPublished().length
  numUnpublished: -> BB.Collections.events.getUnpublished().length

  # ----- event selectors -----

  firstEvent: -> BB.Collections.events.sortBy((e) -> e.get('start'))[0]
  lastEvent:  -> BB.Collections.events.sortBy((e) -> e.get('start')).slice(-1)[0]

  firstEventDate: -> @toMoment(@firstEvent().get('start')).strftime("%b-%Y")
  lastEventDate:  -> @toMoment(@lastEvent().get('start')).strftime("%b-%Y")

  upcomingStart:  moment()
  upcomingFinish: moment().add("weeks", 6)
  recentStart:    moment().subtract("weeks", 4)
  recentFinish:   moment()

  toMoment: (date) -> moment(date, "YYYY-MM-DD HH:mm")

  eventDates: (event) -> [@toMoment(event.get('start')), @toMoment(event.get('finish'))]

  isCurrent: (event) ->
    [eventStart, eventFinish] = @eventDates(event)
    if eventFinish
      eventStart < moment() < eventFinish
    else
      moment().subtract('days', 3) < eventStart < moment()

  isRecent: (event) ->
    return false if @isCurrent(event)
    [eventStart, eventFinish] = @eventDates(event)
    @recentStart < eventStart < @recentFinish

  isUpcoming: (event) ->
    return false if @isCurrent(event)
    [eventStart, eventFinish] = @eventDates(event)
    @upcomingStart < eventStart < @upcomingFinish

  isInRange: (event) -> @recentStart < @toMoment(event.get('start')) < @upcomingFinish

  sortByStart: (list) -> _.sortBy list, (event) -> event.get('start')
  currentEvents:  -> @sortByStart(_.select(@eventList, (event) => @isCurrent(event) ))
  recentEvents:   -> @sortByStart(_.select(@eventList, (event) => @isRecent(event)  )).reverse()
  upcomingEvents: -> @sortByStart(_.select(@eventList, (event) => @isUpcoming(event)))

  # ----- headers -----

  currentEventsTitle: ->
    switch @currentEvents().length
      when 0 then "No current events."
      when 1 then "Current event:"
      else "Current events:"

  upcomingEventsTitle: ->
    start  = @upcomingStart.strftime("%b-%d")
    finish = @upcomingFinish.strftime("%b-%d")
    "Upcoming events (#{start} to #{finish}):"

  recentEventsTitle: ->
    start  = @recentStart.strftime("%b-%d")
    finish = @recentFinish.strftime("%b-%d")
    "Recent events (#{finish} back to #{start}):"

  # ----- event display -----

  eventsRow: (ev) =>
    eventLink = (ev) =>
      title    = ev.get('title')
      location = ev.get('location')
      date     = BB.Helpers.ExtDateHelpers.hShowDate(ev.get('start'), ev.get('finish'), ev.get('all_day'), "%a %b-%d")
      label    = "#{title} @ #{location} <b>#{date}</b>"
      "<a class='eventRowLink' href='/events/#{ev.id}'>#{label}</a>"
    """
    <tr>
      <td width=70><nobr>#{_.string.capitalize(ev.get('typ'))} - </nobr></td>
      <td>#{eventLink(ev)}</td>
    </tr>
    """

  eventsRows: (list) ->
    _.map(list, (ev) => @eventsRow(ev)).join(' ')

  eventsTable: (eventList) ->
    return "" if eventList.length == 0
    """
    <table class='eventTable'>
     #{ @eventsRows(eventList) }
    </table>
    """
