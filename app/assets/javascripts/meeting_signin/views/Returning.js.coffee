class BB.Views.Returning extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Returning'

  initialize: (meetingId) ->
    @meetingId = meetingId
    @setupMeetingAndPeriod(meetingId)

  # ----- initialization -----

  onRender: ->
    @setHomeLink "returning", @meetingId
    @setLabel    "returning"
    setTimeout(@initializePage, 1)
    @setupAutoComplete()

  # ----- local methods -----

  setupAutoComplete: ->
    autoOpts =
      source: BB.members.autoCompleteRoster()
      minLength: 3
      select: (event, ui) => @autoCompleteAddParticipant(ui.item.memberId)
    @$el.find('#autoComp').autocomplete(autoOpts)
    $('#autoComp').focus()

  autoCompleteAddParticipant: (memberId) =>
    member = @addParticipant(memberId)
    $('#autoComp').hide()
    $('#welcomeText').html(@welcomeText(member)).show()
    #$('#photoLink').html(photoLink).show() unless member.hasPhoto()
    $('#homeButton').html(@homeButton()).show()
    setTimeout(@setHeight,  1)
    setTimeout(@hideUrlBar, 5)

  # ----- text blocks... -----

  welcomeText: (member) -> """
    <b>Welcome #{member.fullName()}!</b>
    <p></p>
    You are signed in.
    <p></p>
  """

  photoLink: (member) -> """
    <b>You have not uploaded a profile photo!</b>
    <p></p>
    <a id='photoClick' class='nav center-text' href='#'>Take a Profile Photo</a>
  """

  homeButton: -> """
    <a class='clickHome nav center-text' href='/meeting_signin/#{@meetingId}' data-id='#{@meetingId}'>Return Home</a>
  """