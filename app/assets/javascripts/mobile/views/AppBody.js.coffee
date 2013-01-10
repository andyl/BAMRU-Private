class BB.Views.AppBody extends Backbone.Marionette.Layout

  # ----- configuration -----

  template : 'mobile/templates/AppBody'
  el       : 'body'

  regions:
    content : '#content'

  events:
    "click .clickHome" : "clickHome"
    "click .clickNav"  : "clickNav"

  # ----- event handlers -----

  clickNav: (ev) ->
    ev.preventDefault()
    href = $(ev.target).attr('href')
    BB.Routers.app.navigate(href, {trigger: true})

  clickHome: (ev) ->
    ev.preventDefault()
    BB.Routers.app.navigate("/mobile", {trigger: true})

  # ----- content region -----

  showContent: (opts) ->
    view = switch opts.page
      when "roster"      then new BB.Views.Roster
      when "first_time"  then new BB.Views.FirstTime
      when "returning"   then new BB.Views.Returning
      when "home"        then new BB.Views.Home
    @content.show(view)


