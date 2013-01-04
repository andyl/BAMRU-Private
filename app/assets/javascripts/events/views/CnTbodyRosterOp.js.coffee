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
    if @collection.length == 0
      @collection.fetch
        success: =>
          @createPeriod() if @collection.length == 0
#    @pubSub = new BB.PubSub.Periods(@collection)
    BB.UI.rosterState = new BB.Models.RosterState(@model.id)
    @bindTo(BB.vent, 'cmd:AddNewPeriod',      @createPeriod, this)
    @bindTo(BB.vent, 'cmd:DeletePeriod',      @deletePeriod, this)
    @bindTo(BB.vent, 'cmd:TogglePeriodTimes', @togglePeriodTimes, this)

  events:
    'click #newPeriod'   : 'createPeriod'
    'click .stateButton' : 'toggleFields'

  onShow: ->
    @periods.show(new BB.Views.CnTbodyRosterOpPeriods({model: @model}))
    BB.hotKeys.enable("CnTbodyRosterOp")

  onClose: ->
#    @pubSub.close()
    BB.hotKeys.disable("CnTbodyRosterOp")

  # ----- initialization -----

  afterFetch: ->
    if @collection.length == 0
      opts =
        success: => @createPeriod()
      @createPeriod()

  # ----- methods -----

  deletePeriod: (ev) ->
    ev?.preventDefault()
    model = @collection.getActive()[0]
    model?.destroy()
    @collection.initActive()

  createPeriod: (ev) ->
    ev?.preventDefault()
    opts =
      event_id: @model.get('id')
      position: @collection.length + 1
    period = new BB.Models.Period(opts)
    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
    opts =
      success: =>
        @collection.add(period)
        @collection.setActive(period.id)
        @collection.resetPositions()
    period.save({}, opts)

  toggleFields: (ev) ->
    newState = @$el.find(".stateButton:checked").attr("id")
    BB.UI.rosterState.set(showTimes: newState)
    BB.UI.rosterState.saveToLocalStorage()

  togglePeriodTimes: (ev) ->
    newState = switch BB.UI.rosterState.get('showTimes')
      when "none"    then "transit"
      when "transit" then "signin"
      else "none"
    BB.UI.rosterState.set({showTimes: newState}, {silent: true})
    BB.UI.rosterState.saveToLocalStorage()
    @render()
    @onShow()

