BB.Helpers.IndexHelpers =

  meetingLabel: =>
    if BB.meetings.length == 1
      "CURRENT MEETING"
    else
      "CURRENT MEETINGS"

  meetingButtons: =>
    noMeetings = "<b>There are no current meetings.</b>"
    return noMeetings if BB.meetings.length == 0
    BB.meetings.map((meeting) =>
      meetingId = meeting.get('id')
      date      = moment(meeting.get('start')).strftime("%b %d")
      label     = "#{meeting.get('title')} - #{date} @ #{meeting.get('location')}"
      button    = (meeting) ->
        "<a class='clickHome nav center-text' data-id='#{meetingId}' href='/meeting_signin/#{meetingId}'>#{label}</a>"
      button(meeting)).join("\n")
