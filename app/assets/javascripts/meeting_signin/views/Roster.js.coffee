class BB.Views.Roster extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Roster'
  templateHelpers: BB.Helpers.RosterHelpers

  initialize: (meetingId) ->
    @meetingId = meetingId
    @setParticipants()
    @bindTo(BB.vent, 'rosterInit', @reRender, this)

  events:
    'click .navDelete' : 'removeParticipant'
    'click .imageShow' : 'imageShow'

  # ----- initialization -----

  onRender: ->
    @setHomeLink 'roster', @meetingId
    @setLabel    'roster'
    setTimeout(@initializePage, 1)

  # ----- local methods -----

  reRender: =>
    @setParticipants()
    @render()

  setParticipants: ->
    meeting      = BB.meetings.get(@meetingId)
    period       = meeting.periods?.first()
    participants = period?.participants
    @model = BB.meetings.get(@meetingId)
    @model.set(period: period)
    @model.set(participants: participants)

  removeParticipant: (ev) ->
    ev.preventDefault()
    alert "Under Construction"
    return
    period = @model.get('period')
    participantId = $(ev.target).data('id')
    participant = period.participants.get(participantId)
    console.log "PART", participantId, period, participant
    participant?.destroy()

  imageShow: (ev) ->
    ev.preventDefault()
    alert "Under Construction"
    return
    period = @model.get('period')
    participantId = $(ev.target).data('id')
    participant = period.participants.get(participantId)
    console.log "PART", participantId, period, participant
    participant?.destroy()


