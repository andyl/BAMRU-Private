class BB.Views.Index extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Index'
  templateHelpers: BB.Helpers.IndexHelpers

  # ----- initialization -----

  onRender: ->
    @setLabel "index"
    setTimeout(@checkUrlBar, 1)

