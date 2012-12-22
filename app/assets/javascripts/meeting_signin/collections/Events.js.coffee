class BB.Collections.Events extends Backbone.Collection

  model: BB.Models.Event

  comparator: (model) ->
    typToken =
      meeting:   'A'
      training:  'B'
      operation: 'C'
      community: 'D'
#      social:    'E'
    typToken[model.get('typ')] + model.get('start')

  url: '/eapi/events'

  # ----- for highlighting events when scrolling up/down -----

  clearActive: ->
    @each (m) -> m.unset('isActive') if m.get('isActive')

  setActive: (modelId) ->
    @clearActive()
    lclModel = @get(modelId)
    lclModel?.set({isActive: true})

  getActive: ->
    @select (m) -> m.get('isActive')

  # ----- selecting / counting -----

  getPublished:   -> @select (m) -> m.get('published')
  getUnpublished: -> @select (m) -> ! m.get('published')

  getMeetings:   => @getTyp('meeting')
  getTrainings:  => @getTyp('training')
  getOperations: => @getTyp('operation')
  getCommunity:  => @getTyp('community')
  getSocial:     => @getTyp('social')
  getTyp: (type) -> @select (e) -> e.get('typ') == type

  # ----- filtering -----

  yearFilter: (year) ->
    @select (e) -> e.get('start').split('-')[0] == year

  # filterObj contains:
  # start:     a date string
  # finish:    a date string
  # meeting:   boolean
  # training:  boolean
  # operation: boolean
  # community: boolean
  # textQuery: string
  objFilter: (filterObj) ->
    @select (event) ->
      dateProc = (s) -> s?.split('-').slice(0,2).join('-')
      startDate = dateProc(event.get('start'))
      finisDate = dateProc(event.get('finish')) || startDate
      modStart  = filterObj.start
      modFinish = filterObj.finish
      # ----- match on date -----
      if startDate < mDate(modStart).strftime("%Y-%m")
        return false
      if finisDate > mDate(modFinish).strftime("%Y-%m")
        return false
      # ----- match on textQuery -----
      if filterObj.textQuery?
        tq = filterObj.textQuery.toLowerCase()
        return false if event.rowText().toLowerCase().indexOf(tq) == -1
      # ----- match on meeting type -----
      eval("filterObj.#{event.get('typ')}")

# see these references:
# http://jsfiddle.net/derickbailey/7tvzF/
# https://groups.google.com/forum/#!msg/backbone-marionette/IC-aelkl9Ps/E7vsuF-NkdQJ
BB.Collections.FilteredEvents = (original) ->

  filtered = new original.constructor

  # saved copy of original filter - not in use - this should be removed...
  filtered.originalFilter = (criteria) ->
    items = if (criteria)
      original.yearFilter(criteria)
    else
      original.models
    filtered.reset(items)

  # this is the main function
  filtered.filter = (filterObj) ->
    @filterObj = filterObj
    items = if (filterObj)
      original.objFilter(filterObj)
    else
      original.models
    filtered.reset(items)

  filtered.selectYear = (year) ->
    items = if (year)
      original.yearFilter(year)
    else
      original.models
    filtered.reset(items)

  # use after items are added/removed
  filtered.reFilter = -> filtered.filter(@filterObj)

  original.on "reset", -> filtered.reset original.models

  filtered.filter()

  filtered