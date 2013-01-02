class BB.Views.Roster extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Roster'
  templateHelpers: BB.Helpers.RosterHelpers

  initialize: (meetingId) ->
    @meetingId = meetingId
    @setParticipants()
    @bindTo(BB.vent, 'rosterInit', @reRender, this)

  events:
    'click .navDelete'  : 'removeParticipant'
    'click .imageShow'  : 'imageShow'
    'click #imageClose' : 'imageClose'

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
    period = @model.get('period')
    participantId = $(ev.target).data('id')
    participant = period.participants.get(participantId)
    member      = BB.members.get(participant.get('member_id'))
    result = confirm("Are you sure you want to remove #{member.fullName()}?")
    return unless result == true
    participant?.destroy()
    @render()

  imageShow: (ev) ->
    ev.preventDefault()
    iconEl  = $(ev.target)[0]
    iconUrl = $(iconEl).attr('src')
    displayUrl = iconUrl.replace('icon', 'roster')
    memberId = $(iconEl).data('memid')
    member   = BB.members.get(memberId)
    $('#memberName').html("#{member.fullName()}<br/>#{member.get('typ')}")
    $('#photoSpot').html("<img onload=\"$('#loadingMsg').hide()\" style='padding:4px; background:white' src='#{displayUrl}'/>")
    $('#rosterBody').hide()
    $('#photoShow').show()

  imageClose: (ev) ->
    ev?.preventDefault()
    $('#photoShow').hide()
    $('#loadingMsg').show()
    $('#rosterBody').show()
