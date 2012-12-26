class BB.Views.Home extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Home'

  # ----- initialization -----

  onRender: ->
    @setFooter "home"
    @setLabel  "home"
    setTimeout(@initializePage, 1)
