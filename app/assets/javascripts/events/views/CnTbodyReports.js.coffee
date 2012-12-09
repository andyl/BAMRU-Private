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

  events:
    'click .editReportSMSO'   : "editSMSO"
    'click .formCancel'       : "editCancel"
    'click #smsoUpdate'       : "updateSMSO"

  # ----- methods -----

  editCancel: (event) ->
    event?.preventDefault()
    @$el.find('.editForm').hide()
    @$el.find('#report-table').show()

  editSMSO: (event) ->
    event?.preventDefault()
    report_id = $(event.target).data('id')
    report = @model.eventReports.get(report_id)
    @$el.find('#smsoSignedBy').val(report.get('data').signed_by)
    @$el.find('#smsoUnitLead').val(report.get('data').unit_leader)
    @$el.find('#smsoDescript').val(report.get('data').description)
    @$el.find('#reportFormSmsoAar').show()
    @$el.find('#report-table').hide()

  updateSMSO: (event) ->
    event?.preventDefault()
    params = Backbone.Syphon.serialize(this)
    if params.finish != ""
      if params.start > params.finish
        [params.start, params.finish] = [params.finish, params.start]
    params.title    = "TBA" if _.string.isBlank(params.title)
    params.location = "TBA" if _.string.isBlank(params.location)
    params.leaders  = "TBA" if _.string.isBlank(params.leaders)
    @model.set params
    @model.save()
    BB.vent.trigger("click:CnTabsOverviewShow")