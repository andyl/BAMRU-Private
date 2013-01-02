BB.Helpers.AutosignHelpers =

  userName: ->
    member = BB.members.get(BB.myID)
    member.fullName()

  homeTitle: ->
    date = moment(@start).strftime("%b %d")
    "#{@title}<br/>#{date} @ #{@location}"

  meetingButtons: =>
    noMeetings = "<b>There are no current meetings.</b>"
    return noMeetings if BB.meetings.length == 0
    BB.meetings.map((meeting) =>
      meetingId = meeting.get('id')
      date      = moment(meeting.get('start')).strftime("%b %d")
      label     = "#{meeting.get('title')} - #{date} @ #{meeting.get('location')}"
      button    = (meeting) ->
        "<a class='clickHome nav center-text' data-id='#{meetingId}' href='/meeting_signin/#{meetingId}'>Home</a>"
      button(meeting)).join("\n")
