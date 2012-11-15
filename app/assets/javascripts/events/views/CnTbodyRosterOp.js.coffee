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
    @pubSub     = new BB.PubSub.Base(@collection)
    unless BB.rosterState?
      BB.rosterState = new Backbone.Model()
      BB.rosterState.set(state: 'none')

  events:
    'click #newPeriod'   : 'createPeriod'
    'click .stateButton' : 'toggleFields'

  onShow: ->
    opts =
      success: => @afterFetch()
    @collection.fetch(opts)
    @periods.show(new BB.Views.CnTbodyRosterOpPeriods({model: @model}))
    BB.hotKeys.enable("CnTbodyRosterOp")

  onClose: ->
    @pubSub.close()
    BB.hotKeys.disable("CnTbodyRosterOp")

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
      position: @collection.length + 1
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: => @collection.add(period)
    period.save({}, opts)

  toggleFields: (ev) ->
    newState = @$el.find(".stateButton:checked").attr("id")
    BB.rosterState.set(state: newState)

