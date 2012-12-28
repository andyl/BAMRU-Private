class BB.Views.Returning extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Returning'

  initialize: (meetingId) ->
    @meetingId = meetingId

  # ----- initialization -----

  onRender: ->
    @setFooter   "returning", @meetingId
    @setHomeLink "returning", @meetingId
    @setLabel    "returning"
    setTimeout(@initializePage, 1)
