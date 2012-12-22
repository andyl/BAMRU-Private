class BB.Views.AppIndex extends BB.Views.AppBase

  # ----- configuration -----

  template: 'meeting_signin/templates/AppIndex'
  el      : '#app-layout'

  regions:
    content  :  '#content'
    footer   :  '#footer'

  events:
    "click .clickNav" : "clickNav"

  # ----- instance methods -----

  clickNav: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data("id")
    BB.Routers.app.navigate("/meeting_signin/#{id}", {trigger: true})

  # ----- initialization -----

  onRender: ->
    @applyScaffold()
#    @bindTo(BB.vent,     'click:CnTabsOverviewClone',       @clone,         this)

