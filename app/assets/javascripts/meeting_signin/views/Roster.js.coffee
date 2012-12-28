class BB.Views.Roster extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Roster'
  templateHelpers: BB.Helpers.RosterHelpers

  initialize: (meetingId) ->
    @meetingId = meetingId
    @setParticipants()
    @bindTo(BB.vent, 'rosterInit', @reRender, this)

  # ----- initialization -----

  onRender: ->
    @setFooter   'roster', @meetingId
    @setHomeLink 'roster', @meetingId
    @setLabel    'roster'
    setTimeout(@initializePage, 1)

  # ----- local methods -----

  reRender: =>
    @setParticipants()
    @render()

  setParticipants: ->
    meeting      = BB.meetings.get(@meetingId)
    participants = meeting.periods?.first()?.participants
    @model = BB.meetings.get(@meetingId)
    @model.set(participants: participants)
