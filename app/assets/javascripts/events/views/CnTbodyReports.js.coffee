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
    @eventFiles  = @model.eventFiles
    @eventPhotos = @model.eventPhotos
    @eventLinks  = @model.eventLinks
    if @collection.length == 0
      @collection.fetch
        success: => @render()

  events:
    'click .editReportSMSO'       : "editSMSO"
    'click .formCancel'           : "editReset"
    'click #smsoUpdate'           : "updateSMSO"
    'click .editReportInternal'   : "editInternal"
    'click .formCancel'           : "editReset"
    'click #internalUpdate'       : "updateInternal"

  # ----- methods -----

  editReset: (event) ->
    event?.preventDefault()
    @$el.find('.editForm').hide()
    @$el.find('#report-table, #report-header').show()

  # ----- SMSO -----

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

  # ----- Internal -----

  setCheck: (el, val) -> el.attr('checked', val)

  editInternal: (event) ->
    event?.preventDefault()
    reportId = $(event.target).data('id')
    report = @model.eventReports.get(reportId)
    @$el.find('#reportFormInternalAar').data('reportId', reportId)
    @$el.find('#internalSignedBy').val(report.get('data').signed_by)
    @$el.find('#internalDescript').val(report.get('data').description)
    @setCheck(@$el.find('#showFiles'),  report.get('data').show_files)
    @setCheck(@$el.find('#showPhotos'), report.get('data').show_photos)
    @setCheck(@$el.find('#showLinks'),  report.get('data').show_links)
    @$el.find('#reportFormInternalAar').show()
    @$el.find('#report-table, #report-header').hide()

  updateInternal: (event) ->
    event?.preventDefault()
    reportId = @$el.find('#reportFormInternalAar').data('reportId')
    report   = @model.eventReports.get(reportId)
    params = {}
    report.setData('signed_by',    @$el.find('#internalSignedBy').val(),    {silent: true})
    report.setData('description',  @$el.find('#internalDescript').val(),    {silent: true})
    report.setData('show_files',   @$el.find('#showFiles').is(':checked'),  {silent: true})
    report.setData('show_photos',  @$el.find('#showPhotos').is(':checked'), {silent: true})
    report.setData('show_links',   @$el.find('#showLinks').is(':checked'))
    report.save()
    @editReset()
