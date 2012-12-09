class BB.Views.CnTbodyReports extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyReports'
  
  templateHelpers: ->
    base = { eventReports: @model.eventReports }
    _.extend(base, BB.Helpers.CnTbodyReportsHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model          # Event
    @model.eventReports.fetch()

  # onShow: ->


  # ----- methods -----

