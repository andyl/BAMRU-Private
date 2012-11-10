class BB.Views.CnTbodyRosterOp extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOp'

  templateHelpers: BB.Helpers.CnTbodyRosterOpHelpers

  regions:
    periods: '#periods'

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model     # Event
    @collection = @model.periods    # Periods
    unless BB.rosterState?
      BB.rosterState = new Backbone.Model()
      BB.rosterState.set(state: 'transit')

  events:
    'click #newPeriod'   : 'createPeriod'
    'click .stateButton' : 'toggleFields'

  onShow: ->
    opts =
      success: => @afterFetch()
    @collection.fetch(opts)
    @periods.show(new BB.Views.CnTbodyRosterOpPeriods({model: @model}))

  # ----- initialization -----

  afterFetch: ->
    if @collection.length == 0
      opts =
        success: => @createPeriod()
      @createPeriod()

  # ----- methods -----

  createPeriod: (ev) ->
    ev?.preventDefault()
    opts =
      event_id: @model.get('id')
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: => @collection.add(period)
    period.save({}, opts)

  toggleFields: (ev) ->
    currentState = BB.rosterState.get('state')
    if currentState == 'transit'
      BB.rosterState.set(state: "signin")
    else
      BB.rosterState.set(state: "transit")

