class BB.Views.CnTbodyRosterOp extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOp'

  regions:
    periods: '#periods'

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model     # Event
    @collection = @model.periods    # Periods

  events:
    'click #newPeriod' : 'createPeriod'

  onShow: ->
    $('#typeRadio').buttonset()
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
    console.log "CREATING", ev
    ev?.preventDefault()
    opts =
      event_id: @model.get('id')
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: => @collection.add(period)
    period.save({}, opts)
