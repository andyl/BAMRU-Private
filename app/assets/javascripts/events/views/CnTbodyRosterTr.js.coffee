class BB.Views.CnTbodyRosterTr extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterTr'

  regions:
    period: '#period'

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model     # Event
    @collection = @model.periods    # Periods

  onShow: ->
    opts = 
      success: => @afterFetch()
      error: -> console.log "ERRORZZ"
    console.log "FETCHING"
    @collection.fetch(opts)

  # ----- methods -----

  afterFetch: ->

    if @collection.length == 0
      console.log "ZERO LEN"
      opts =
        success: => @createPeriod()
      @createPeriod(opts)
    else
      console.log "SOME LEN", @collection, @collection.first()
      @showPeriod()

  showPeriod: ->
    periodModel = @collection.first()
    periodView  = new BB.Views.CnTbodyRosterTrPeriod({model: periodModel})
    @period.show(periodView)

  createPeriod: ->
    console.log "CREATING PERIOD"
    opts =
      event_id: @model.get('id')
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: => @collection.add(period); @showPeriod()
    period.save({}, opts)
