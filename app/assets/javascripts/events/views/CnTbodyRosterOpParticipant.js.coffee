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
    @render()
    BB.vent.trigger("OLParticipantChange")

  events:
    'click .deleteParticipant' : 'deleteParticipant'
    'click .unsetOL'           : 'unsetOL'
    'click .setOL'             : 'setOL'
    'click .startNow'          : 'startNow'
    'click .finishNow'         : 'finishNow'
    'click .startAll'          : 'startAll'
    'click .finishAll'         : 'finishAll'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    answer = confirm("Are you sure you want to remove this participant?")
    if answer == true
      @model.destroy()

  unsetOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : false})

  setOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : true})

  # ----- start / finish tags -----

  startNow: (ev) ->
    ev?.preventDefault()
    textInput = "#en_route_at#{@model.id}"
    @$el.find(textInput).val(moment().strftime("%Y-%m-%d %H:%M"))
    @handleDateFields("en_route_at", "return_home_at")

  finishNow: (ev) ->
    ev?.preventDefault()
    textInput = "#return_home_at#{@model.id}"
    @$el.find(textInput).val(moment().strftime("%Y-%m-%d %H:%M"))
    @handleDateFields("en_route_at", "return_home_at")

  startAll: (ev) =>
    ev?.preventDefault()
    common_date = @model.get('signed_in_at') || ""
    msg = "Set all Sign-in times to '#{common_date}'?"
    if confirm(msg)
      _.each @model.collection.models, (model) =>
        signed_out_at = model.get('signed_out_at') || ""
        [start, finish] = @sortDates(common_date, signed_out_at)
        model.save({signed_in_at: start, signed_out_at: finish})

  finishAll: (ev) =>
    ev?.preventDefault()
    common_date = @model.get('signed_out_at') || ""
    msg = "Set all Sign-out times to '#{common_date}'?"
    if confirm(msg)
      _.each @model.collection.models, (model) =>
        signed_in_at = model.get('signed_in_at') || ""
        [start, finish] = @sortDates(signed_in_at, common_date)
        model.save({signed_out_at: finish, signed_in_at: start})

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
  handleSigninFields:  => @handleDateFields("signed_in_at", "signed_out_at")

  sortDates: (start, finish) ->
    return [start, ""] if finish == ""
    return ["", ""]    if start  == ""
    if start <= finish then [start, finish] else [finish, start]

  handleDateFields: (startTag, finishTag) ->
    startTagId = "##{startTag}#{@model.id}"
    finishTagId = "##{finishTag}#{@model.id}"
    frmStart  = @$el.find(startTagId).val()  || ""
    mdlStart  = @model.get("#{startTag}")    || ""
    frmFinish = @$el.find(finishTagId).val() || ""
    mdlFinish = @model.get("#{finishTag}")   || ""
    return if mdlStart == frmStart && mdlFinish == frmFinish
    [retStart, retFinish] = @sortDates(frmStart, frmFinish)
    opts = {}
    opts[startTag]  = retStart
    opts[finishTag] = retFinish
    opts["updated_at"]   = moment().strftime("%y-%m-%d %H:%M")
    @model.save opts

  setAll: (type, date) =>
