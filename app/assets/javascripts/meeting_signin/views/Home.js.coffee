class BB.Views.Home extends BB.Views.Content

  # ----- initialization -----

  initialize: (id) ->
    @meetingId = id
    @model  = BB.meetings.get(@meetingId)

  # ----- configuration -----

  template: 'meeting_signin/templates/Home'
  templateHelpers: BB.Helpers.HomeHelpers

  # ----- initialization -----

  onRender: ->
    @setFooter "home", @meetingId
    @setLabel  "home"
    setTimeout(@initializePage, 1)
