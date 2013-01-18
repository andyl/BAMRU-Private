class BB.Views.CnTbodyReports extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyReports'
  
  templateHelpers: ->
    base = { eventReports: @model.eventReports }
    _.extend(base, BB.Helpers.CnTbodyReportsHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model               # Event
    @collection = @model.eventReports
    if @collection.length == 0
      @collection.fetch
        success: => @render()

  events:
    'click .editReportSMSO'   : "editSMSO"
    'click .formCancel'       : "editReset"
    'click #smsoUpdate'       : "updateSMSO"

  # ----- methods -----

  editReset: (event) ->
    event?.preventDefault()
    @$el.find('.editForm').hide()
    @$el.find('#report-table, #report-header').show()

  editSMSO: (event) ->
    event?.preventDefault()
    reportId = $(event.target).data('id')
    report = @model.eventReports.get(reportId)
    @$el.find('#reportFormSmsoAar').data('reportId', reportId)
    @$el.find('#smsoSignedBy').val(report.get('data').signed_by)
    @$el.find('#smsoUnitLead').val(report.get('data').unit_leader)
    @$el.find('#smsoDescript').val(report.get('data').description)
    @$el.find('#reportFormSmsoAar').show()
    @$el.find('#report-table, #report-header').hide()

  updateSMSO: (event) ->
    event?.preventDefault()
    reportId = @$el.find('#reportFormSmsoAar').data('reportId')
    report   = @model.eventReports.get(reportId)
    params = {}
    report.setData('unit_leader', @$el.find('#smsoUnitLead').val(), {silent: true})
    report.setData('signed_by',   @$el.find('#smsoSignedBy').val(), {silent: true})
    report.setData('description', @$el.find('#smsoDescript').val())
    report.save()
    @editReset()
