class BB.Views.CnTbodyRosterOpParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model       # Participant
    @bindTo(@model, 'change:ol', @reRender, this)

  reRender: ->
    BB.vent.trigger("OLParticipantChange")
    @render()

  events:
    'click .deleteParticipant' : 'deleteParticipant'
    'click .unsetOL'           : 'unsetOL'
    'click .setOL'             : 'setOL'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  unsetOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : false})

  setOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : true})

  # ----- setup date pickers for transit and signin fields -----

  onRender: ->
    @$el.find("td").css('font-size', '8pt')
    @setupDatePicker("transitPick", @handleTransitFields)
    @setupDatePicker("signinPick", @handleSigninFields)

  setupDatePicker: (typKlas, handlerFunc) ->
    @$el.find(".#{typKlas}").datetimepicker
      showMonthAfterYear: true
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      onClose           : handlerFunc

    # ----- handlers for transit and signing fields

  handleTransitFields: => @handleDateFields("en_route_at", "return_home_at")
  handleSigninFields: => @handleDateFields("signed_in_at", "signed_out_at")

  handleDateFields: (startTag, finishTag) ->
    startTagId = "##{startTag}#{@model.id}"
    finishTagId = "##{finishTag}#{@model.id}"
    frmStart  = @$el.find(startTagId).val()
    mdlStart  = @model.get("#{startTag}")
    frmFinish = @$el.find(finishTagId).val()
    mdlFinish = @model.get("#{finishTag}")
    return if mdlStart == frmStart && mdlFinish == frmFinish
    retStart  = if frmStart <= frmFinish then frmFinish else frmStart
    retFinish = if frmStart <= frmFinish then frmStart  else frmFinish
    opts = {}
    opts["#{startTag}"]  = retStart
    opts["#{finishTag}"] = retFinish
    opts["updated_at"]   = moment().strftime("%y-%m-%d %H:%M")
    console.log "HANDLING", frmStart, frmFinish, retStart, retFinish
    @model.save opts
