class BB.Views.Roster extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Roster'

  # ----- initialization -----

  onRender: ->
    @setFooter   'roster'
    @setHomeLink 'roster'
    @setLabel    'roster'
    setTimeout(@initializePage, 1)

