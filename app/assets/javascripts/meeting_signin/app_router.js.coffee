BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes:
    'meeting_signin'                 : "index"
    'meeting_signin/'                : "index"
    'meeting_signin/:id'             : "home"
    'meeting_signin/:id/'            : "home"
    'meeting_signin/:id/first_time'  : "first_time"
    'meeting_signin/:id/first_time/' : "first_time"
    'meeting_signin/:id/returning'   : "returning"
    'meeting_signin/:id/returning/'  : "returning"
    'meeting_signin/:id/roster'      : "roster"
    'meeting_signin/:id/roster/'     : "roster"
    'meeting_signin/*path'           : "default"

  initialize: ->
    console.log "doing initialize"
    # ----- faye -----
#    BB.PubSub.events = new BB.PubSub.Events(BB.Collections.events)
    # ----- current member -----
#    json_member_data = JSON.parse(_.string.unescapeHTML($('#json_member_data').text()))
#    BB.currentMember = new BB.Models.Member(json_member_data)
    # ----- create app layout -----
    BB.Views.appBody = new BB.Views.AppBody()
    @appBody = BB.Views.appBody
    # ----- all members -----
#    BB.members = new BB.Collections.Members()
#    BB.members.fetch()

  index: ->
    console.log "rendering index"
    @appBody.render().content.show(new BB.Views.Index)

  home: (id) ->
    console.log "rendering home for #{id}"
    view = new BB.Views.Home
    view.render()
    @appBody.render().content.show(view)

  first_time: (id) ->
    console.log "rendering first_time for #{id}"
    @appBody.render().content.show(new BB.Views.FirstTime)

  returning: (id) ->
    console.log "rendering returning for #{id}"
    @appBody.render().content.show(new BB.Views.Returning)

  roster: (id) ->
    console.log "rendering roster for #{id}"
    @appBody.render().content.show(new BB.Views.Roster)

  default: ->
    console.log "rendering the default route"
    $('#content').text("This is the default route")

  _missingEventMsg: (id) ->
    if BB.Collections.events.get(id)
      "Event is in the datbase but not in the filtered list."
    else
      "Event is not in the database."
      
  _showMissingEvent: (id) ->
    msg = @_missingEventMsg(id)
    @appBody.content.show(new BB.Views.CnMissingEvent({eventId: id, missingEventMessage: msg}))
    
  _render: (opts) ->
    @appBody.render().showContent(opts)
