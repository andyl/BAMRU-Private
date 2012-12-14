class BB.Collections.Events extends Backbone.Collection

  model: BB.Models.Event

  comparator: (model) ->
    typToken =
      meeting:   'A'
      training:  'B'
      operation: 'C'
      community: 'D'
      social:    'E'
    typToken[model.get('typ')] + model.get('start')

  url: '/eapi/events'

  clearActive: ->
    @each (m) -> m.unset('isActive') if m.get('isActive')

  setActive: (modelId) ->
    @clearActive()
    lclModel = @get(modelId)
    lclModel?.set({isActive: true})

  getActive: ->
    @select (m) -> m.get('isActive')

  yearFilter: (year) ->
    @select (e) -> e.get('start').split('-')[0] == year

  getPublished:   -> @select (m) -> m.get('published')
  getUnpublished: -> @select (m) -> ! m.get('published')

  getMeetings:   => @getTyp('meeting')
  getTrainings:  => @getTyp('training')
  getOperations: => @getTyp('operation')
  getCommunity:  => @getTyp('community')
  getSocial:     => @getTyp('social')
  getTyp: (type) ->
    @select (e) -> e.get('typ') == type

  objFilter: (filterObj) ->
    @select (e) ->
      dateProc = (s) -> s?.split('-').slice(0,2).join('-')
      startDate = dateProc(e.get('start'))
      finisDate = dateProc(e.get('finish')) || startDate
      modStart  = filterObj.start
      modFinish = filterObj.finish
      if startDate < mDate(modStart).strftime("%Y-%m")
        return false
      if finisDate > mDate(modFinish).strftime("%Y-%m")
        return false
      eval("filterObj.#{e.get('typ')}")


BB.Collections.FilteredEvents = (original) ->

  filtered = new original.constructor

  filtered.originalFilter = (criteria) ->
    items = if (criteria)
      original.yearFilter(criteria)
    else
      original.models
    filtered.reset(items)

  filtered.filter = (filterObj) ->
    @filterObj = filterObj
    items = if (filterObj)
      original.objFilter(filterObj)
    else
      original.models
    filtered.reset(items)

  filtered.reFilter = -> filtered.filter(@filterObj)

  filtered.selectYear = (year) ->
    items = if (year)
      original.yearFilter(year)
    else
      original.models
    filtered.reset(items)

  original.on "reset", -> filtered.reset original.models

  filtered.filter()

  filtered