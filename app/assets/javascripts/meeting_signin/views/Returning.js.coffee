class BB.Views.Returning extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Returning'

  # ----- initialization -----

  onRender: ->
    @setFooter   "returning"
    @setHomeLink "returning"
    @setLabel    "returning"
    setTimeout(@initializePage, 1)
