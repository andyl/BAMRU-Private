class BB.Views.FirstTime extends BB.Views.Content

  # ----- configuration -----

  initialize: (meetingId) ->
    @meetingId = meetingId

  template: 'meeting_signin/templates/FirstTime'

  # ----- initialization -----

  onRender: =>
    @setFooter   "first_time", @meetingId
    @setHomeLink "first_time", @meetingId
    @setLabel    "first_time"
    setTimeout(@initializePage, 1)
