class BB.Views.Autosign extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Autosign'
  templateHelpers: BB.Helpers.AutosignHelpers

  # ----- initialization -----

  initialize: ->
    @model   = BB.meetings.first()
    @member  = BB.members.get(BB.myID)
    @setupMeetingAndPeriod(@model.get('id'))
    argo = => @addParticipant(BB.myID)
    setTimeout( argo, 2000)
