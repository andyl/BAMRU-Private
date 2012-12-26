class BB.Views.AppBody extends Backbone.Marionette.Layout

  # ----- configuration -----

  template : 'meeting_signin/templates/AppBody'
  el       : 'body'

  regions:
    content : '#content'
    footer  : '#footer'

  events:
    'click .clickHome' : 'clickHome'
    "click .navLink"   : "navClick"
    "click .clickNav"  : "clickNav"

  # ----- event handlers -----

  clickNav: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data("id")
    BB.Routers.app.navigate("/meeting_signin/#{id}", {trigger: true})

  clickHome: (ev) ->
    ev.preventDefault()
    BB.Routers.app.navigate("/meeting_signin/234", {trigger: true})

  navClick: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data('id')
    typ = $(ev.target).data('typ')
    if typ == "meetings"
      BB.Routers.app.navigate("/meeting_signin", {trigger: true})
    else
      BB.Routers.app.navigate("/meeting_signin/#{id}/#{typ}", {trigger: true})

  # ----- content region -----

  showContent: (opts) ->
    console.log "SHOW", opts.page
    view = switch opts.page
      when "roster"      then new BB.Views.Roster
      when "first_time"  then new BB.Views.FirstTime
      when "returning"   then new BB.Views.Returning
      when "home"        then new BB.Views.Home
    @content.show(view)
