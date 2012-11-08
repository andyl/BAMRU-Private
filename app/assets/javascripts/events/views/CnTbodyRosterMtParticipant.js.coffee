class BB.Views.CnTbodyRosterMtParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterMtParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterMtParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model       # Participant
    @bindTo(@model, 'change', @render, this)

  events:
    'click .deleteParticipant'       : 'deleteParticipant'

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