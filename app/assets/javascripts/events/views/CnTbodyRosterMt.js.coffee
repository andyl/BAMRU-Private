class BB.Views.CnTbodyRosterMt extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterMt'

  regions:
    period: '#period'

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model     # Event
    @collection = @model.periods    # Periods


  onShow: ->
    opts = 
      success: => @afterFetch()
    @collection.fetch(opts)

  # ----- methods -----

  afterFetch: ->
    if @collection.length == 0
      opts =
        success: => @createPeriod()
      @createPeriod(opts)
    else
      @showPeriod()

  showPeriod: ->
    periodModel = @collection.first()
    periodView  = new BB.Views.CnTbodyRosterMtPeriod({model: periodModel})
    @period.show(periodView)

  createPeriod: ->
    opts =
      event_id: @model.get('id')
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: => @collection.add(period); @showPeriod()
    period.save({}, opts)
