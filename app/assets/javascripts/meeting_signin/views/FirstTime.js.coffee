class BB.Views.FirstTime extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/FirstTime'

  # ----- initialization -----

  onRender: ->
    @setFooter   "first_time"
    @setHomeLink "first_time"
    @setLabel    "first_time"
    setTimeout(@initializePage, 1)
