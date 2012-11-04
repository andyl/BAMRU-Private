BB.Helpers.CnIndxHelpers =

  numEvents: (type) ->
    events = BB.Collections.events
    return events.length if type == "all"
    
  numMeetings:   -> BB.Collections.events.getMeetings().length
  numTrainings:  -> BB.Collections.events.getTrainings().length
  numOperations: -> BB.Collections.events.getOperations().length
  numCommunity:  -> BB.Collections.events.getCommunity().length
  numSocial:     -> BB.Collections.events.getSocial().length

  firstEvent: -> BB.Collections.events.sortBy((e) -> e.get('start'))[0]
  lastEvent:  -> BB.Collections.events.sortBy((e) -> e.get('start')).slice(-1)[0]

  firstEventDate: -> moment(@firstEvent().get('start')).strftime("%b-%Y")
  lastEventDate:  -> moment(@lastEvent().get('start')).strftime("%b-%Y")

  currentEvents: -> []

  recentEvents:  -> []

  upcomingEvents: -> []

  currentEventsTitle: ->
    switch @currentEvents().length
      when 0 then "No current events"
      when 1 then "One current event"
      when 2 then "Two current events"
      when 3 then "Three current events"
      when 4 then "Four current events"
      when 5 then "Five current events"
      when 6 then "Six current events"
      when 7 then "Seven current events"
      when 8 then "Eight current events"
      else "Many current events"

  currentEventsRow: (ev) ->
    eventLink= (ev) ->
      "<a href='/events/#{ev.id}'>#{ev.get('title')} @ ${ev.get('location')}</a>"
    """
    <tr>
      <td>#{_.string(ev.get('typ')).capitalize()}</td>
      <td>#{@eventLink(ev)}</td>
    </tr>
    """

  currentEventsRows: (list) ->
    _.map(list, (ev) -> @currentEventsRow(ev)).join(' ')

  currentEventsTable: ->
    cEv = @currentEvents()
    return "" if cEv.length == 0
    """
    <table class='eventTable'>
     #{ @currentEventsRows(cEv) }
    </table>
    """


_.extend(BB.Helpers.CnIndxHelpers, BB.Helpers.ExtDateHelpers)