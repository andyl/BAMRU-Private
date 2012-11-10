class BB.Views.CnTbodyRosterOpParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model       # Participant
    @bindTo(@model, 'change', @render, this)

  events:
    'click .deleteParticipant' : 'deleteParticipant'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  onRender: ->
    removeHighLight = =>
      @model.unset('pubSub')
      @model.unset('newMember')
    growl = =>
      participantId = @model.get('member_id')
      participant   = BB.members.get(participantId)
      userId   = @model.get('pubSub').userid
      user     = BB.members.get(userId)
      userName = user.fullName()
      action   = @model.get('pubSub').action
      showMsg  = (msg) -> toastr.info msg
      msg = switch action
        when "update"  then  showMsg "#{participant.shortName()} updated by #{userName}"
        when "add"     then  showMsg "#{participant.shortName()} added by #{userName}"
    if @model.get('pubSub')
      growl()
      window.setTimeout(removeHighLight, 3000)
    if @model.get('newMember')
      window.setTimeout(removeHighLight, 3000)
    @$el.find("#enroute#{@model.id}, #return#{@model.id}").datetimepicker
      showMonthAfterYear: true
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      onClose           : =>
        formEnRoute  = @$el.find("#enroute#{@model.id}").val()
        modelEnRoute = @model.get('en_route_at')
        formReturn   = @$el.find("#return#{@model.id}").val()
        modelReturn  = @model.get('return_home_at')
        return if modelEnRoute == formEnRoute && modelReturn == formReturn
        returnVal = if formEnRoute >= modelReturn then "" else modelReturn
        @model.save
          en_route_at    : formEnRoute
          return_home_at : returnVal
          updated_at     : moment().strftime("%y-%m-%d %H:%M")
    @$el.find("#checkedIn#{@model.id}, #checkedOut#{@model.id}").datetimepicker
      showMonthAfterYear: true
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      onClose           : =>
        formCheckedIn   = @$el.find("#checkedIn#{@model.id}").val()
        modelCheckedIn  = @model.get('checked_in_at')
        formCheckedOut  = @$el.find("#checkedOut#{@model.id}").val()
        modelCheckedOut = @model.get('checked_out_at')
        return if modelCheckedIn == formCheckedIn && modelCheckedOut == formCheckedOut
        returnVal = if formCheckedIn >= modelCheckedOut then "" else modelCheckedOut
        @model.save
          checked_in_at  : formCheckedIn
          checked_out_at : returnVal
          updated_at     : moment().strftime("%y-%m-%d %H:%M")