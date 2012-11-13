class BB.Views.CnSharedForm extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnSharedForm'

  templateHelpers: BB.Helpers.CnSharedFormHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model = options?.model || new BB.Models.Event()
    @bindTo(BB.vent, 'cmd:EditEventSave',   @save,   this)
    @bindTo(BB.vent, 'cmd:EditEventCancel', @cancel, this)

  events:
    'click #CnTabsOverviewForm-cancel' : "cancel"
    'click #CnTabsOverviewForm-save'   : "save"
    'click #geoButton'                 : "geoPicker"
    'click #ckAllDay'                  : "toggleAllDay"

  onShow: ->
    BB.hotKeys.disable("SidebarList")
    BB.hotKeys.disable("SidebarControl")
    BB.hotKeys.disable("CnTabsMenu")
    BB.hotKeys.enable("CnSharedForm")
    if @model.get('all_day') then @setDatePicker() else @setDateTimePicker()
    setTimeout(@setFocus, 250)

  onClose: ->
    BB.hotKeys.disable("CnSharedForm")
    BB.hotKeys.enable("SidebarList")
    BB.hotKeys.enable("SidebarControl")

  # ----- methods -----

  setFocus: -> $('#titleField').focus()

  setDatePicker: ->
    @$el.find("#start, #finish").datetimepicker("destroy")
    @$el.find("#start, #finish").datepicker
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      showMonthAfterYear: true

  setDateTimePicker: ->
    @$el.find("#start, #finish").datepicker("destroy")
    @$el.find("#start, #finish").datetimepicker
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      showMonthAfterYear: true
      stepMinute        : 15
      showButtonPanel   : false
  formatFieldsForDateOnly: ->
    start = @$el.find("#start").val().split(' ')[0]
    finish = @$el.find("#finish").val().split(' ')[0]
    [finish, start] = [start, finish] if start > finish
    finish = "" if start == finish
    @$el.find("#start").val(start)
    @$el.find("#finish").val(finish)

  formatFieldsForDateTime: ->
    eventTyp = $('#typSelect').val()
    [startTime, finishTime] = ["09:00", "17:00"]
    [startTime, finishTime] = ["19:30", "21:30"] if eventTyp == "meeting"
    start = @$el.find("#start").val().split(' ')[0]
    finish = @$el.find("#finish").val().split(' ')[0]
    finish = start if finish == ""
    [finish, start] = [start, finish] if start > finish
    @$el.find("#start").val("#{start} #{startTime}")
    @$el.find("#finish").val("#{finish} #{finishTime}")


  toggleAllDay: ->
    if @$el.find("#ckAllDay").is(':checked')
      @setDatePicker()
      @formatFieldsForDateOnly()
    else
      @setDateTimePicker()
      @formatFieldsForDateTime()

  cancel: (event) ->
    event?.preventDefault()
    BB.vent.trigger("click:CnTabsOverviewShow")

  save: (event) ->
    console.log "FORM SAVE EVENT INVOKED"

  geoPicker: ->
    formLat = $('#lat').val()
    formLon = $('#lon').val()
    blankStart =
      startAddress: 'Redwood City, California'
    geoStart =
      startPositionLat : formLat
      startPositionLng : formLon
    baseOpts =
      mapType        : 'terrain'
      backgroundColor: 'red'
      windowTitle    : 'BAMRU GeoPicker'
      locateme       : 'false'
      returnCallback : 'updateLatLon'
    startOpts = if formLat != "" && formLon != "" then geoStart else blankStart
    _.extend(baseOpts, startOpts)
    myGeoPositionGeoPicker baseOpts

window.updateLatLon = (data) ->
  rLat = data.lat.toFixed(5)
  rLon = data.lng.toFixed(5)
  $('#lat').val(rLat)
  $('#lon').val(rLon)