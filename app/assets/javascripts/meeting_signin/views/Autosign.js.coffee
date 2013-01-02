class BB.Views.Autosign extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Autosign'
  templateHelpers: BB.Helpers.AutosignHelpers

  # ----- initialization -----

  initialize: ->
    console.log "STARTTT"
    @model   = BB.meetings.first()
    @member  = BB.members.get(BB.myID)
    @setupMeetingAndPeriod(@model.get('id'))
    console.log "THIS", @
    argo = => @addParticipant(BB.myID)
    setTimeout( argo, 2000)

  onRender: ->
    console.log "RENDERRR"
#    @setLabel "autosign"
#    setTimeout(@checkUrlBar, 1)

