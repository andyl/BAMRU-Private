class BB.Collections.Events extends Backbone.Collection

  model: BB.Models.Event

  comparator: (model) ->
    typToken =
      meeting:   'A'
      training:  'B'
      operation: 'C'
      community: 'D'
    typToken[model.get('typ')] + model.get('start')

  url: '/eapi/events'

  # ----- initialize -----

  initialize: (args) ->
    super(args)
    @bind('reset', @setupPeriods)
    @reset(BB.meetingsJson)

  # ----- instance methods -----

  setupPeriods: =>
    @each (meeting) ->
      respSucc = =>
        if meeting.periods.length == 0
          newPeriod = new BB.Models.Period({event_id: meeting.get('id')})
          newPeriod.urlRoot = "/eapi/events/#{meeting.get('id')}/periods"
          newPeriod.save()
          meeting.periods.add(newPeriod)
          BB.vent.trigger('rosterInit')
        else
          sucFun = => BB.vent.trigger('rosterInit')
          meeting.periods.first().participants.fetch({success: sucFun})
      meeting.periods.fetch({success: respSucc})
