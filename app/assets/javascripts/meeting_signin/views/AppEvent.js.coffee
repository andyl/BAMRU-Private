class BB.Views.AppEvent extends BB.Views.AppBase

  # ----- configuration -----

  template: 'meeting_signin/templates/AppEvent'
  el      : '#app-layout'

  regions:
    content  :  '#content'

  events:
    'click .back' : 'clickHome'

  # ----- initialization -----

  onRender: ->
    @applyScaffold()
#    @bindTo(BB.vent,     'click:CnTabsOverviewClone',       @clone,         this)

  # ----- event handlers -----

  clickHome: (ev) ->
    ev.preventDefault()
    BB.Routers.app.navigate("/meeting_signin/234", {trigger: true})

  # ----- tabs -----

  showContent: (opts) ->
    console.log "SHOW", opts.page
    view = switch opts.page
      when "roster"      then new BB.Views.Roster
      when "first_time"  then new BB.Views.FirstTime
      when "returning"   then new BB.Views.Returning
      when "home"        then new BB.Views.Home
    @content.show(view)
