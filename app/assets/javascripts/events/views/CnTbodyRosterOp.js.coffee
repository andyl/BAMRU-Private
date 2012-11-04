class BB.Views.CnTbodyRosterOp extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOp'

  regions:
    periods: '#periods'

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model     # Event
    @collection = @model.periods    # Periods

  onShow: ->
    @createPeriod() if @collection.length == 0
    @periods.show(new BB.Views.CnTbodyRosterOpPeriods({model: @model}))

  events:
    'click #newPeriod'          : 'createPeriod'

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
