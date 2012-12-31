BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes:
    'meeting_signin'                      : "index"
    'meeting_signin/'                     : "index"
    'meeting_signin/:id'                  : "home"
    'meeting_signin/:id/'                 : "home"
    'meeting_signin/:id/first_time'       : "first_time"
    'meeting_signin/:id/first_time/'      : "first_time"
    'meeting_signin/:id/returning'        : "returning"
    'meeting_signin/:id/returning/'       : "returning"
    'meeting_signin/:id/roster'           : "roster"
    'meeting_signin/:id/roster/'          : "roster"
    'meeting_signin/:mtgId/photo/:memId'  : "photo"
    'meeting_signin/:mtgId/photo/:memId/' : "photo"
    'meeting_signin/*path'                : "default"

  initialize: ->
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
#    @appBody.render().content.show(new BB.Views.Home(id))
    @_render(id, new BB.Views.Home(id))

  first_time: (id) ->
    console.log "rendering first_time for #{id}"
    @_render(id, new BB.Views.FirstTime(id))

  returning: (id) ->
    console.log "rendering returning for #{id}"
    @_render(id, new BB.Views.Returning(id))

  roster: (id) ->
    console.log "rendering roster for #{id}"
    @_render(id, new BB.Views.Roster(id))

  photo: (meetingId, memberId) ->
    console.log "rendering photo for #{meetingId} and member #{memberId}"
    @_render(meetingId, new BB.Views.Photo(meetingId, memberId))

  default: ->
    console.log "rendering the default route"
    @appBody.render().content.show(new BB.Views.Unrecognized)

  _missingEventMsg: (id) ->
    if BB.Collections.events.get(id)
      "Event is in the datbase but not in the filtered list."
    else
      "Event is not in the database."
      
  _showMissingEvent: (id) ->
    msg = @_missingEventMsg(id)
    @appBody.content.show(new BB.Views.CnMissingEvent({eventId: id, missingEventMessage: msg}))
    
  _render: (id, view) ->
    if BB.meetings.get(id)
      @appBody.render().content.show(view)
    else
      @appBody.render().content.show(new BB.Views.Unrecognized("Unknown Meeting (ID ##{id})"))
